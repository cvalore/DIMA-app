const googleBookAPIKey = 'AIzaSyAIbNkEmTSHCeggxoGFlN7D0WiFFORuewA';
const googleBookAPIFields = 'items(id,volumeInfo(title,authors,publisher,publishedDate,description,industryIdentifiers,pageCount,categories,averageRating,ratingsCount,imageLinks,language))';
const imageWidth = 128.0;
const imageHeight = 198.0;

const editBookPopupIndex = 1;
const deleteBookPopupIndex = 2;

const mobileMaxWidth = 540;
const tabletMaxWidth = 1280;

const orderByNoOrderLabel = "No Order";
//const orderByNoOrderLabelValue = 0;
const orderByTitleLabel = "Title";
//const orderByTitleValue = 1;
const orderByAuthorLabel = "Author";
//const orderByAuthorValue  = 2;
const orderByISBNLabel = "ISBN";
//const orderByISBNValue  = 3;
const orderByPriceLabel = "Price";
//const orderByPriceValue  = 4;
const orderByPageCountLabel = "Page Count";
//const orderByPageCountValue  = 5;
const orderByAvgRatingLabel = "Average Rating";
//const orderByAvgRatingValue  = 6;
const orderByImagesLabel = "Images";
//const orderByImagesValue  = 7;
const orderByStatusLabel = "Status";
//const orderByStatusValue  = 8;

const orderByLabels = [
  orderByNoOrderLabel, orderByTitleLabel, orderByAuthorLabel,
  orderByISBNLabel, orderByPriceLabel, orderByPageCountLabel,
  orderByAvgRatingLabel, orderByImagesLabel, orderByStatusLabel
];

const orderByAscendingWay = "Ascending";
const orderByAscendingWayValue = 0;
const orderByDescendingWay = "Descending";
const orderByDescendingWayValue = 1;

const orderByWays = [orderByAscendingWay, orderByDescendingWay];
