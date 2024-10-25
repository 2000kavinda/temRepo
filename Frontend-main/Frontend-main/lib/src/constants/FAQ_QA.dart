// Questions
const quest1 = "What is datatype ?";
const quest2 = "What is if condition ?";
const quest3 = "What is a loop ?";

// Answers
const ans1 = {
  'eng': 'data type serves as a means to inform the computer about the nature of the information being dealt with',
  'tamil': "தரவு வகையானது, கையாளப்படும் தகவலின் தன்மையைப் பற்றி கணினிக்குத் தெரிவிக்கும் ஒரு வழியாகும்"
};

const ans2 = {
  'eng': "If' is a special word in computer talk that helps us tell the computer what to do in different situations. It's like saying, 'If something happens, then do this.",
  'tamil': "If' என்பது கணினி பேச்சில் உள்ள ஒரு சிறப்பு வார்த்தையாகும், இது வெவ்வேறு சூழ்நிலைகளில் என்ன செய்ய வேண்டும் என்பதை கணினிக்கு சொல்ல உதவுகிறது. 'ஏதாவது நடந்தால், இதைச் செய்யுங்கள்' என்று சொல்வது போல் இருக்கிறது."
};

const ans3 = {
  'eng': "A loop is like a special command that tells the computer to do something over and over again.",
  'tamil': "Loop என்பது ஒரு சிறப்பு கட்டளையைப் போன்றது, இது கணினியை மீண்டும் மீண்டும் செய்யச் சொல்கிறது."
};

final List<Map<String, dynamic>> faqData = [
  {'question': quest1, 'answer': ans1},
  {'question': quest2, 'answer': ans2},
  {'question': quest3, 'answer': ans3},
];