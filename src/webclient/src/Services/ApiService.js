import axios from "axios";
import SearchParams from "../SearchParams";

class ApiService {
  constructor(baseUrl) {
    this.client = axios.create({ baseURL: baseUrl });
    this.client.interceptors.request.use((request) => {
      //console.log("Starting Request", JSON.stringify(request, null, 2));
      return request;
    });

    this.client.interceptors.response.use((response) => {
      //console.log("Response:", JSON.stringify(response, null, 2));
      return response;
    });
  }

  delay(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  async getConventions(searchInfo) {
    const queryString = new SearchParams(searchInfo).toQueryString();
    const url = `conventions${queryString}`;
    console.log(url);
    const consResponse = await this.client.get(url);
    if (consResponse.status !== 200) {
      throw Error(
        `Conventions call ${url} returned an error. Status=${consResponse.status} - ${consResponse.statusText}`
      );
    }
    return consResponse.data;
  }

  async getConventionsByBounds(bounds) {
    const results = [];
    const boundsQuery = `north=${bounds.north}&east=${bounds.east}&south=${bounds.south}&west=${bounds.west}`;
    let hasMore = true;
    let currentPage = 1;

    while (hasMore) {
      let url = `conventions/bounds?${boundsQuery}&page=${currentPage}`;
      const consResponse = await this.client.get(url);
      if (consResponse.status !== 200) {
        throw Error(
          `Conventions by bounds call ${url} returned an error. Status=${consResponse.status} - ${consResponse.statusText}`
        );
      }
      results.push(...consResponse.data.conventions);
      hasMore = currentPage < consResponse.data.totalPages;
      currentPage = currentPage + 1;
    }
    return results;
  }

  async postConvention(conventionData, accessToken) {
    let url = "conventions";

    const config = {
      headers: { Authorization: `Bearer ${accessToken}` },
    };

    const postResponse = await this.client.post(url, conventionData, config);
    if (postResponse.status !== 201) {
      throw Error(
        `Conventions by bounds call ${url} returned an error. Status=${postResponse.status} - ${postResponse.statusText}`
      );
    }
  }
}

export default ApiService;
