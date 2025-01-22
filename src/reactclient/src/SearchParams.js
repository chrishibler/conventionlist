export default class SearchParams {
  constructor({
    category,
    search,
    startRange,
    endRange,
    lat,
    lon,
    orderBy,
    page,
  }) {
    this.category = category;
    this.search = search;
    this.startRange = startRange;
    this.endRange = endRange;
    this.lat = lat;
    this.lon = lon;
    this.orderBy = orderBy;
    this.page = page;
  }

  toQueryString() {
    const queryStringArray = [];
    if (this.category) {
      queryStringArray.push(`category=${this.category}`);
    }

    if (this.search) {
      queryStringArray.push(`search=${this.search}`);
    }

    if (this.startRange) {
      queryStringArray.push(`startRange=${this.startRange}`);
    }

    if (this.endRange) {
      queryStringArray.push(`endRange=${this.endRange}`);
    }

    if (this.lat) {
      queryStringArray.push(`lat=${this.lat}`);
    }

    if (this.lon) {
      queryStringArray.push(`lon=${this.lon}`);
    }

    if (this.orderBy) {
      queryStringArray.push(`orderBy=${this.orderBy}`);
    }

    if (this.page) {
      queryStringArray.push(`page=${this.page}`);
    }

    if (queryStringArray.length === 0) {
      return "";
    } else {
      return `?${queryStringArray.join("&")}`;
    }
  }
}
