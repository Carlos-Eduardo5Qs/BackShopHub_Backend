require('dotenv').config();

const B2 = require('backblaze-b2');

const CheckProduct = require('../../models/products/SearchProductModel');
const UpdatedProductModel = require('../../models/products/UpdateProductModel');

function UpdateProduct(id, name, image, description, price, category, brand, stock) {
  this.id = id;
  this.name = name;
  this.image = image;
  this.description = description;
  this.price = price;
  this.category = category;
  this.brand = brand;
  this.stock = stock;

  this.b2 = new B2({
    applicationKeyId: process.env.KEY_ID,
    applicationKey: process.env.APP_KEY,
  });
}

UpdateProduct.prototype.updateProduct = async function () {
  try {
    const updateImages = await this.updateImage();

    const product = [
      this.name,
      updateImages.url,
      updateImages.id,
      updateImages.fileName,
      this.description,
      this.price,
      this.category,
      this.brand,
      this.stock,
      this.id,
    ];

    const update = new UpdatedProductModel(product);
  } catch (error) {
    throw new Error(error.message);
  }
};

UpdateProduct.prototype.updateImage = async function () {
  const product = await this.searchProduct();

  if (!product) throw new Error('Product not found.');

  const fileExists = await this.doesFileExist(product.image_filename);

  if (!fileExists) throw new Error('Error when updating product.');

  await this.deleteImage(product.image_filename, product.image_id);

  const update = await this.uploadImage();

  return update;
};

UpdateProduct.prototype.uploadImage = async function () {
  const authResponse = await this.b2.authorize();
  const { downloadUrl } = authResponse.data;

  const response = await this.b2.getUploadUrl({ bucketId: process.env.BUCKET_ID });
  const { authorizationToken, uploadUrl } = response.data;

  const params = {
    uploadUrl,
    uploadAuthToken: authorizationToken,
    fileName: `products/${this.image.originalname}`,
    data: this.image.buffer,
  };

  const fileInfo = await this.b2.uploadFile(params);

  const url = `${downloadUrl}/file/${process.env.BUCKET_NAME}/${params.fileName}`;

  return { url, id: fileInfo.data.fileId, fileName: fileInfo.data.fileName };
};

UpdateProduct.prototype.deleteImage = async function (fileName, fileId) {
  try {
    await this.b2.authorize();

    await this.b2.deleteFileVersion({
      fileName,
      fileId,
    });
  } catch (error) {
    console.error(`Error deleting file ${fileName} with fileId ${fileId}: ${error.message}`);
  }
};

UpdateProduct.prototype.searchProduct = async function () {
  const checkProduct = new CheckProduct(this.id);
  const product = await checkProduct.find();
  return product;
};

UpdateProduct.prototype.doesFileExist = async function (fileName) {
  try {
    await this.b2.authorize();

    const file = await this.b2.listFileNames({
      bucketId: process.env.BUCKET_ID,
      startFileName: fileName,
      maxFileCount: 1,
    });

    if (file.data.files.length === 0) {
      return false;
    } else {
      return true;
    }
  } catch (error) {
    console.log(error);
  }
};

module.exports = UpdateProduct;
