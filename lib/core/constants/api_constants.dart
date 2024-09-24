class ApiConstants {
  static const String API_BASE_URL = "https://api.openai.com/v1";
  // static const String API_KEY = "API-KEY";
  static const List<Map<String, dynamic>> GPT_MODELS_URLS= [
    {
      'model': 'gpt-3.5-turbo-0301',
      'url': API_BASE_URL + '/chat/completions',
      'method': 2, 
    },
    {
      'model': 'gpt-3.5-turbo',
      'url': API_BASE_URL + '/chat/completions',
      'method': 2, 

    },
    ////
    {
      'model': 'text-davinci-003',
      'url': API_BASE_URL + '/completions',
      'method': 1, 
    },
    {
      'model': 'text-davinci-002',
      'url': API_BASE_URL + '/completions',
      'method': 1, 

    },
    {
      'model': 'text-curie-001',
      'url': API_BASE_URL + '/completions',
      'method': 1, 

    },
    {
      'model': 'text-babbage-001',
      'url': API_BASE_URL + '/completions',
      'method': 1, 

    },
    {
      'model': 'text-ada-001',
      'url': API_BASE_URL + '/completions',
      'method': 1, 

    },
    {
      'model': 'davinci',
      'url': API_BASE_URL + '/completions',
      'method': 1, 

    },
    {
      'model': 'curie',
      'url': API_BASE_URL + '/completions',
      'method': 1, 

    },
    {
      'model': 'babbage',
      'url': API_BASE_URL + '/completions',
      'method': 1, 

    },
    {
      'model': 'ada',
      'url': API_BASE_URL + '/completions',
      'method': 1, 

    },
  ];
}
