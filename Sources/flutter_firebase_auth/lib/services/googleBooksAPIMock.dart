
import 'package:flutter_firebase_auth/services/googleBooksAPI.dart';

class GoogleBooksAPIMock implements GoogleBooksAPI {
  Future performSearch(String title, String author) async {
    print("MOCK: performSearch() method");

    dynamic result = {
      "items": [
        {
          "id": "9CJWTbd-RYoC",
          "volumeInfo": {
            "title": "Harry Potter e la Pietra Filosofale",
            "authors": [
              "J.K. Rowling"
            ],
            "publisher": "Pottermore Publishing",
            "publishedDate": "2015-12-08",
            "description": "Harry Potter è un ragazzo normale, o quantomeno è convinto di esserlo, anche se a volte provoca strani fenomeni, come farsi ricrescere i capelli inesorabilmente tagliati dai perfidi zii. Vive con loro al numero 4 di Privet Drive: una strada di periferia come tante, dove non succede mai nulla fuori dall’ordinario. Finché un giorno, poco prima del suo undicesimo compleanno, riceve una misteriosa lettera che gli rivela la sua vera natura: Harry è un mago e la Scuola di Magia e Stregoneria di Hogwarts è pronta ad accoglierlo...",
            "industryIdentifiers": [
              {
                "type": "ISBN_13",
                "identifier": "9781781101582"
              },
              {
                "type": "ISBN_10",
                "identifier": "1781101582"
              }
            ],
            "pageCount": 302,
            "categories": [
              "Fiction"
            ],
            "averageRating": 4.5,
            "ratingsCount": 61,
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=9CJWTbd-RYoC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=9CJWTbd-RYoC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
            },
            "language": "un"
          }
        },
        {
          "id": "OSl1OHVZgdgC",
          "volumeInfo": {
            "title": "Harry Potter e il Principe Mezzosangue",
            "authors": [
              "J.K. Rowling"
            ],
            "publisher": "Pottermore Publishing",
            "publishedDate": "2015-12-08",
            "description": "È il sesto anno a Hogwarts e per Harry niente è più come prima. L’ultimo legame con la sua famiglia è troncato, perfino la scuola non è la dimora accogliente di un tempo. Voldemort ha radunato le sue forze e nessuno può più negare il suo ritorno. Nel clima di crescente paura e sconforto che lo circonda, Harry capisce che è arrivato il momento di affrontare il suo destino. L’ultimo atto si avvicina, sarà all’altezza di questa sfida fatale?",
            "industryIdentifiers": [
              {
                "type": "ISBN_13",
                "identifier": "9781781102169"
              },
              {
                "type": "ISBN_10",
                "identifier": "1781102163"
              }
            ],
            "pageCount": 567,
            "categories": [
              "Fiction"
            ],
            "averageRating": 4.5,
            "ratingsCount": 19,
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=OSl1OHVZgdgC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=OSl1OHVZgdgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
            },
            "language": "un"
          }
        },
        {
          "id": "H1RCT73xWlsC",
          "volumeInfo": {
            "title": "Harry Potter e la Camera dei Segreti",
            "authors": [
              "J.K. Rowling"
            ],
            "publisher": "Pottermore Publishing",
            "publishedDate": "2015-12-08",
            "description": "A Hogwarts il nuovo anno scolastico s’inaugura all’insegna di fatti inquietanti: strane voci riecheggiano nei corridoi e Ginny sparisce nel nulla. Un antico mistero si nasconde nelle profondità del castello e incombe ora sulla scuola, toccherà a Harry, Ron e Hermione risolvere l’enigma che si cela nella tenebrosa Camera dei Segreti...",
            "industryIdentifiers": [
              {
                "type": "ISBN_13",
                "identifier": "9781781102121"
              },
              {
                "type": "ISBN_10",
                "identifier": "1781102120"
              }
            ],
            "pageCount": 326,
            "categories": [
              "Fiction"
            ],
            "averageRating": 4.5,
            "ratingsCount": 36,
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=H1RCT73xWlsC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=H1RCT73xWlsC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
            },
            "language": "un"
          }
        },
        {
          "id": "8RREzQEACAAJ",
          "volumeInfo": {
            "title": "Harry Potter 03 e il prigioniero di azkaban",
            "authors": [
              "Joanne K. Rowling"
            ],
            "publishedDate": "2020-01-23",
            "industryIdentifiers": [
              {
                "type": "ISBN_10",
                "identifier": "8831003402"
              },
              {
                "type": "ISBN_13",
                "identifier": "9788831003407"
              }
            ],
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=8RREzQEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=8RREzQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
            },
            "language": "un"
          }
        },
        {
          "id": "pUc1swouaGYC",
          "volumeInfo": {
            "title": "Harry Potter e l'Ordine della Fenice",
            "authors": [
              "J.K. Rowling"
            ],
            "publisher": "Pottermore Publishing",
            "publishedDate": "2015-12-08",
            "description": "Il quinto anno a Hogwarts si annuncia carico di sfide difficili. Harry non è mai stato così irrequieto: Lord Voldemort è tornato. Che cosa succederà ora che il Signore Oscuro è di nuovo in pieno possesso dei suoi terrificanti poteri? Al contrario di Silente, il Ministro della Magia sembra non prendere sul serio questa spaventosa minaccia. Toccherà a Harry organizzare la resistenza, con l’aiuto degli amici di sempre e il tumultuoso coraggio dell’adolescenza.",
            "industryIdentifiers": [
              {
                "type": "ISBN_13",
                "identifier": "9781781102152"
              },
              {
                "type": "ISBN_10",
                "identifier": "1781102155"
              }
            ],
            "pageCount": 853,
            "categories": [
              "Fiction"
            ],
            "averageRating": 4,
            "ratingsCount": 18,
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=pUc1swouaGYC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=pUc1swouaGYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
            },
            "language": "un"
          }
        },
        {
          "id": "k8FADQEACAAJ",
          "volumeInfo": {
            "title": "Harry Potter e la maledizione dell'erede",
            "authors": [
              "Joanne K. Rowling",
              "John Tiffany",
              "Jack Thorne"
            ],
            "publishedDate": "2016",
            "industryIdentifiers": [
              {
                "type": "ISBN_10",
                "identifier": "8869187497"
              },
              {
                "type": "ISBN_13",
                "identifier": "9788869187490"
              }
            ],
            "pageCount": 368,
            "categories": [
              "Juvenile Fiction"
            ],
            "averageRating": 4,
            "ratingsCount": 5,
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=k8FADQEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=k8FADQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
            },
            "language": "un"
          }
        },
        {
          "id": "QbIuW_sntocC",
          "volumeInfo": {
            "title": "Harry Potter e il Prigioniero di Azkaban",
            "authors": [
              "J.K. Rowling"
            ],
            "publisher": "Pottermore Publishing",
            "publishedDate": "2015-12-08",
            "description": "Una terribile minaccia incombe sulla Scuola di Magia e Stregoneria di Hogwarts. Sirius Black, il famigerato assassino, è evaso dalla prigione di Azkaban. È in caccia e la sua preda è proprio a Hogwarts, dove Harry e i suoi amici stanno per cominciare il loro terzo anno. Nonostante la sorveglianza dei Dissennatori la scuola non è più un luogo sicuro, perché al suo interno si nasconde un traditore...",
            "industryIdentifiers": [
              {
                "type": "ISBN_13",
                "identifier": "9781781102138"
              },
              {
                "type": "ISBN_10",
                "identifier": "1781102139"
              }
            ],
            "pageCount": 392,
            "categories": [
              "Fiction"
            ],
            "averageRating": 4.5,
            "ratingsCount": 63,
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=QbIuW_sntocC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=QbIuW_sntocC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
            },
            "language": "un"
          }
        },
        {
          "id": "uP0JzAEACAAJ",
          "volumeInfo": {
            "title": "Harry Potter: La pietra filosofale-La camera dei segreti-Il prigioniero di Azkaban",
            "authors": [
              "J. K. Rowling"
            ],
            "publishedDate": "2019",
            "industryIdentifiers": [
              {
                "type": "ISBN_10",
                "identifier": "8893819910"
              },
              {
                "type": "ISBN_13",
                "identifier": "9788893819916"
              }
            ],
            "categories": [
              "Juvenile Fiction"
            ],
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=uP0JzAEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=uP0JzAEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
            },
            "language": "un"
          }
        },
        {
          "id": "XEFEMQAACAAJ",
          "volumeInfo": {
            "title": "Fierobecco",
            "authors": [
              "J. K. Rowling"
            ],
            "industryIdentifiers": [
              {
                "type": "ISBN_10",
                "identifier": "889367114X"
              },
              {
                "type": "ISBN_13",
                "identifier": "9788893671149"
              }
            ],
            "categories": [
              "Juvenile Fiction"
            ],
            "language": "un"
          }
        },
        {
          "id": "eRgXMjAl5MMC",
          "volumeInfo": {
            "title": "Harry Potter e i Doni della Morte",
            "authors": [
              "J.K. Rowling"
            ],
            "publisher": "Pottermore Publishing",
            "publishedDate": "2015-12-08",
            "description": "Il confronto finale con Voldemort è imminente, una grande battaglia è alle porte e Harry, con coraggio, compirà ciò che dev’essere fatto. Mai i perché sono stati così tanti e mai come in questo libro si ha la soddisfazione delle risposte. Giunti all’ultima pagina si vorrà rileggere tutto daccapo, per chiudere il cerchio e ritardare il distacco dai meravigliosi personaggi che ci hanno accompagnato per così tanto tempo.",
            "industryIdentifiers": [
              {
                "type": "ISBN_13",
                "identifier": "9781781102176"
              },
              {
                "type": "ISBN_10",
                "identifier": "1781102171"
              }
            ],
            "pageCount": 656,
            "categories": [
              "Fiction"
            ],
            "averageRating": 4.5,
            "ratingsCount": 66,
            "imageLinks": {
              "smallThumbnail": "http://books.google.com/books/content?id=eRgXMjAl5MMC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
              "thumbnail": "http://books.google.com/books/content?id=eRgXMjAl5MMC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
            },
            "language": "un"
          }
        }
      ]
    };
    return result;
  }

  String getISBN10(dynamic selected) {
    print("MOCK: getISBN10() method");
    return null;
  }

  String getISBN13(dynamic selected) {
    print("MOCK: getISBN13() method");
    return null;
  }
}