import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/data_providers/locations_provider.dart';
import 'package:frontend_flutter/api/models/responses/location_responses/get_locations_response.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';

class LocationsScreenBody extends StatefulWidget {
  const LocationsScreenBody({super.key});

  @override
  _LocationsScreenBodyState createState() => _LocationsScreenBodyState();
}

class _LocationsScreenBodyState extends State<LocationsScreenBody> {
  Timer? _debounce;
  static const int debounceDuration = 1500;
  bool _isSortedByRating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationsProvider =
          Provider.of<LocationsProvider>(context, listen: false);
      if (!locationsProvider.hasFetched) {
        locationsProvider.fetchLocations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                toolbarHeight: 65.0,
                backgroundColor: AppMainTheme.blueLevelFive,
                title: Text(
                  'Clinics',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      icon: const Icon(Icons.sort, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _isSortedByRating = !_isSortedByRating;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Consumer<LocationsProvider>(
                      builder: (context, locationsProvider, child) {
                        return Column(
                          children: [
                            Text(
                              'Selected Range: ${locationsProvider.selectedRange.toInt()} km',
                              style: GoogleFonts.roboto(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: AppMainTheme.blueLevelFive,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: AppMainTheme.blueLevelFive,
                                  inactiveTrackColor: AppMainTheme.blueLevelTwo,
                                  thumbColor: AppMainTheme.blueLevelFive,
                                  overlayColor:
                                      AppMainTheme.blueLevelFive.withAlpha(32),
                                  valueIndicatorColor:
                                      AppMainTheme.blueLevelFive,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 12.0),
                                  valueIndicatorShape:
                                      const PaddleSliderValueIndicatorShape(),
                                ),
                                child: Slider(
                                  min: 1,
                                  max: 50,
                                  value: locationsProvider.selectedRange,
                                  label:
                                      '${locationsProvider.selectedRange.toInt()} km',
                                  onChanged: (value) {
                                    locationsProvider
                                        .updateSelectedRange(value);
                                    _onSliderChanged(value, locationsProvider);
                                  },
                                ),
                              ),
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
                    if (locationsProvider.errorMessage != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {});
                      return Center(
                        child: ElevatedButton(
                          onPressed: () {
                            locationsProvider.resetError();
                            locationsProvider.fetchLocations();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppMainTheme.blueLevelFive,
                          ),
                          child: const Text('Retry',
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }
                    if (locationsProvider.clinics == null ||
                        locationsProvider.clinics!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 70,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No clinics available.',
                              style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    List<Clinic> clinics = locationsProvider.clinics!;
                    if (_isSortedByRating) {
                      clinics = List.from(clinics)
                        ..sort((a, b) => b.rating!.compareTo(a.rating!));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 0.0),
                      itemCount: clinics.length,
                      itemBuilder: (context, index) {
                        final clinic = clinics[index];
                        return ClinicItem(clinic: clinic);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Consumer<LocationsProvider>(
            builder: (context, locationsProvider, child) {
              return LoadingOverlay(isLoading: locationsProvider.isLoading);
            },
          ),
        ],
      ),
    );
  }

  void _onSliderChanged(double value, LocationsProvider locationsProvider) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: debounceDuration), () {
      locationsProvider.fetchLocations();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class ClinicItem extends StatelessWidget {
  final Clinic clinic;

  const ClinicItem({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    final locationsProvider = Provider.of<LocationsProvider>(context);
    final image = clinic.photoReference != null
        ? locationsProvider.imageCache[clinic.photoReference!]
        : null;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.memory(image,
                    width: 60, height: 60, fit: BoxFit.cover),
              )
            : const Icon(Icons.image, size: 60, color: Colors.grey),
        title: Text(
          clinic.name ?? '',
          style: GoogleFonts.roboto(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: AppMainTheme.blueLevelFive),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(clinic.address),
            if (clinic.rating != null)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('${clinic.rating} (${clinic.numberOfReviews} reviews)'),
                ],
              ),
            if (clinic.openStatus != null)
              Text(
                clinic.openStatus!,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: clinic.openStatus == 'Open'
                      ? Colors.green
                      : clinic.openStatus == 'Closed'
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.map_sharp, color: AppMainTheme.blueLevelFive),
          onPressed: () => openMapsSheet(context, clinic),
        ),
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
                        coords: Coords(clinic.location.latitude,
                            clinic.location.longitude),
                        title: clinic.name ?? '',
                        description: clinic.address,
                        extraParams: {
                          'query': '${clinic.name}, ${clinic.address}',
                          'query_place_id': clinic.placeId
                        },
                      ),
                      title: Text(map.mapName),
                      leading: Image.asset(
                        'assets/icons/${map.mapName.toLowerCase()}.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(
            context, "Failed to open maps application. Please try again.");
      }
    }
  }
}
