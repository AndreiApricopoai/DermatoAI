const sharp = require('sharp');

const validateImage = async (req, res, next) => {
  if (!req.file) {
    return res.status(400).send('No image uploaded.');
  }

  try {
    const image = sharp(req.file.buffer);
    const metadata = await image.metadata();

    if (metadata.width < 600 || metadata.height < 450 || Math.abs(metadata.width / metadata.height - 4 / 3) > 0.01) {
      return res.status(400).send('Image must be at least 600x450 pixels and approximately a 4:3 aspect ratio.');
    }

    next();
  } catch (error) {
    console.error('Image validation error:', error);
    return res.status(500).send('Failed to process image.');
  }
};

module.exports = validateImage;
