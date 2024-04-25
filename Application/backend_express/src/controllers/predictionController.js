const predictionService = require('../services/predictionService');

exports.createPrediction = async (req, res) => {
    if (!req.file) {
        return res.status(400).send('Image upload failed.');
    }
    
    try {
      console.log(req.file);
      return res.status(200).send('Image uploaded successfully.');
        //const { title, description } = req.body;
        //const userId = req.user._id; // Assuming user ID is attached to req.user
        
        // Service handles all logic
        //const prediction = await predictionService.createPrediction(userId, title, description, req.file.buffer);
        
        //res.status(201).json({ success: true, message: 'Prediction created and job queued.', predictionId: prediction._id });
    } catch (error) {
        console.error('Error in creating prediction:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
};
