const mongoose = require('mongoose');

const predictionSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User ID is required']
  },
  workerTokenHash: {
    type: String,
    required: [true, 'Worker token hash is required']
  },
  title: {
    type: String,
    required: [true, 'Title is required'],
    default: 'Untitled',
    trim: true,
    minlength: [1, 'Title must be at least 1 character long'],
    maxlength: [100, 'Title can be no more than 100 characters long']
  },
  description: {
    type: String,
    default: 'No description',
    trim: true,
    minlength: [1, 'Description must be at least 1 character long'],
    maxlength: [1000, 'Description can be no more than 1000 characters long']
  },
  imageUrl: {
    type: String,
    required: [true, 'Image URL is required']
  },
  isHealthy: {
    type: Boolean,
    default: null
  },
  diagnosisName: {
    type: String,
    default: null,
  },
  diagnosisCode: {
    type: Number,
    default: null,
    min: 0,
    max: 8
  },
  diagnosisType: {
    type: String,
    enum: ['cancer', 'not_cancer', 'potentially_cancer', 'unknown'],
    default: null
  },
  confidenceLevel: {
    type: Number,
    default: null,
    min: 0,
    max: 100
  },
  status: {
    type: String,
    enum: ['pending', 'processed', 'failed'],
    default: 'pending'
  }
}, {
  collection: 'predictions',
  timestamps: true
});

predictionSchema.pre('save', function (next) {
  if (this.isModified('status')
      && this.status === 'processed'
      && (this.isHealthy === null 
          || this.diagnosisName === null 
          || this.diagnosisCode === null 
          || this.diagnosisType === null 
          || this.confidenceLevel === null))
  {
    next(new Error('Complete diagnosis information must be provided for processed predictions.'));
  }
  else 
  {
    next();
  }
});

const Prediction = mongoose.model('Prediction', predictionSchema);

module.exports = Prediction;