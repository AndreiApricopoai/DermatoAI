const regexPatterns = {
  nameRegex: /^[a-zA-Z',.\- ]+$/,
  emailRegex: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
};

const dermatologicalChat = {
  model: "gpt-3.5-turbo",
  context: "You are a helpful dermatological doctor.",
  maxTokens: 20,
};

module.exports = {
  regexPatterns,
  dermatologicalChat,
};
