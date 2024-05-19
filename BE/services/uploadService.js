import cloudinary from "../utils/cloudinary.js";
import sharp from "sharp";
const uploadImage = async (imagePath) => {
  try {
    return sharp(imagePath)
      .resize({ width: 400, height: 400 })
      .jpeg({ quality: 80 }) 
      .toBuffer() 
      .then((resizedImageBuffer) => {
        return new Promise((resolve, reject) => {
          cloudinary.uploader
            .upload_stream({ resource_type: "image" }, (error, result) => {
              if (error) {
                reject(error);
              } else {
                console.log(result);
                resolve(result.public_id);
              }
            })
            .end(resizedImageBuffer);
        });
      });
  } catch (error) {
    console.log(error);
  }
};
export { uploadImage };
