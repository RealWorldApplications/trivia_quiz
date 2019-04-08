class Trivia {
  int responseCode;
  List<Results> results;
  Trivia({this.responseCode, this.results});

  Trivia.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }
}

class Results {
  String category;
  String type;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;
  Results(
      {this.category,
        this.type,
        this.question,
        this.correctAnswer,
        this.incorrectAnswers
  });
  Results.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    type = json['type'];
    question = json['question'];
    correctAnswer = json['correct_answer'];
    incorrectAnswers = json['incorrect_answers'].cast<String>();
  }
}
