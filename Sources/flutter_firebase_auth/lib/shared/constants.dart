const googleBookAPIKey = 'AIzaSyAIbNkEmTSHCeggxoGFlN7D0WiFFORuewA';
const googleBookAPIFields = 'items(id,volumeInfo(title,authors,publisher,publishedDate,description,industryIdentifiers,pageCount,categories,averageRating,ratingsCount,imageLinks,language))';
const imageWidth = 128.0;
const imageHeight = 198.0;

const editBookPopupIndex = 1;
const deleteBookPopupIndex = 2;

const mobileMaxWidth = 540;
const tabletMaxWidth = 1280;

const orderByNoOrderLabel = "No Order";
const orderByTitleLabel = "Title";
const orderByAuthorLabel = "Author";
const orderByPublishedDateLabel = "Published Date";
const orderByPriceLabel = "Price";
const orderByPageCountLabel = "Page Count";
const orderByRatingsCountLabel = "Ratings Count";
const orderByImagesLabel = "Images";
const orderByStatusLabel = "Status";

const orderByLabels = [
  orderByNoOrderLabel, orderByTitleLabel, orderByAuthorLabel,
  orderByPublishedDateLabel, orderByPriceLabel, orderByPageCountLabel,
  orderByRatingsCountLabel, orderByImagesLabel, orderByStatusLabel
];

const orderByAscendingWay = "Ascending";
const orderByAscendingWayValue = 0;
const orderByDescendingWay = "Descending";
const orderByDescendingWayValue = 1;

const orderByWays = [orderByAscendingWay, orderByDescendingWay];
