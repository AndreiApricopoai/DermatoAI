const nameRegex = /^[a-zA-Z',.\- ]+$/;
const emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;

module.exports = {
  nameRegex,
  emailRegex
};