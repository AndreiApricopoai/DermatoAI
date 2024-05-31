import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/data_providers/locations_provider.dart';
import 'package:frontend_flutter/api/models/responses/location_responses/get_locations_response.dart';

class LocationsScreenBody extends StatefulWidget {
  @override
  _LocationsScreenBodyState createState() => _LocationsScreenBodyState();
}

class _LocationsScreenBodyState extends State<LocationsScreenBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationsProvider>(context, listen: false).fetchLocations(Provider.of<LocationsProvider>(context, listen: false).selectedRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Consumer<LocationsProvider>(
                builder: (context, locationsProvider, child) {
                  return Column(
                    children: [
                      Text('Select Range (km): ${locationsProvider.selectedRange.toInt()}'),
                      Slider(
                        min: 1,
                        max: 50,
                        value: locationsProvider.selectedRange,
                        onChanged: (value) {
                          locationsProvider.fetchLocations(value);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<LocationsProvider>(
            builder: (context, locationsProvider, child) {
              if (locationsProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (locationsProvider.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(locationsProvider.errorMessage ?? 'An error occurred.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      locationsProvider.resetError();
                      locationsProvider.fetchLocations(locationsProvider.selectedRange);
                    },
                    child: Text('Retry'),
                  ),
                );
              }
              if (locationsProvider.clinics == null || locationsProvider.clinics!.isEmpty) {
                return Center(child: Text('No results found.'));
              }
              return ListView.builder(
                itemCount: locationsProvider.clinics!.length,
                itemBuilder: (context, index) {
                  final clinic = locationsProvider.clinics![index];
                  return ClinicItem(clinic: clinic);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ClinicItem extends StatelessWidget {
  final Clinic clinic;

  const ClinicItem({Key? key, required this.clinic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(clinic.name ?? 'Unknown'),
      subtitle: Text(clinic.address ?? 'No address provided'),
      trailing: IconButton(
        icon: Icon(Icons.map),
        onPressed: () => openMapsSheet(context, clinic),
      ),
    );
  }

  void openMapsSheet(BuildContext context, Clinic clinic) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: Coords(clinic.location!.latitude, clinic.location!.longitude),
                        title: clinic.name ?? '',
                        description: clinic.address,
                        extraParams: {
                          'query': '${clinic.name}, ${clinic.address}',
                          'query_place_id': clinic.placeId
                        }
                      ),
                      title: Text(map.mapName),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open maps.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}