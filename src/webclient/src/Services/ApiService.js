import SearchParams from "../SearchParams";
import { createContext } from "react";

export const ApiServiceContext = createContext(null);

class ApiService {
  constructor(client) {
    this.conventionsUrl = "conventions";
    this.userConventionsUrl = "user/conventions";
    this.client = client;
    this.client.interceptors.request.use((request) => {
      //console.log("Starting Request", JSON.stringify(request, null, 2));
      return request;
    });

    this.client.interceptors.response.use((response) => {
      //console.log("Response:", JSON.stringify(response, null, 2));
      return response;
    });
  }

  async getConventions(searchInfo) {
    const queryString = new SearchParams(searchInfo).toQueryString();
    const url = `${this.conventionsUrl}${queryString}`;
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
      let url = `${this.conventionsUrl}/bounds?${boundsQuery}&page=${currentPage}`;
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

  async getUserConventions(accessToken, pageNumber) {
    let url = `${this.userConventionsUrl}?page=${pageNumber}`;
    let config = this.getTokenConfig(accessToken);
    console.log(url);
    console.log(config);
    const consResponse = await this.client.get(url, config);
    if (consResponse.status !== 200) {
      throw Error(
        `Conventions call ${this.userConventionsUrl} returned an error. Status=${consResponse.status} - ${consResponse.statusText}`
      );
    }
    return consResponse.data;
  }

  async postConvention(conventionData, accessToken) {
    const postResponse = await this.client.post(
      this.conventionsUrl,
      conventionData,
      this.getTokenConfig(accessToken)
    );
    if (postResponse.status !== 201) {
      throw Error(
        `Conventions by bounds call ${this.conventionsUrl} returned an error. Status=${postResponse.status} - ${postResponse.statusText}`
      );
    }
  }

  async putConvention(conventionData, accessToken) {
    const putResponse = await this.client.put(
      `${this.conventionsUrl}/${conventionData.id}`,
      conventionData,
      this.getTokenConfig(accessToken)
    );
    if (putResponse.status !== 204) {
      throw Error(
        `Put conventions call ${this.conventionsUrl} returned an error. Status=${putResponse.status} - ${putResponse.statusText}`
      );
    }
  }

  async deleteConvention(id, accessToken) {
    const deleteResponse = await this.client.delete(
      `${this.conventionsUrl}/${id}`,
      this.getTokenConfig(accessToken)
    );
    if (deleteResponse.status !== 204) {
      throw Error(
        `Delete convention call ${this.conventionsUrl} returned an error. Status=${deleteResponse.status} - ${deleteResponse.statusText}`
      );
    }
  }

  getTokenConfig(accessToken) {
    return {
      headers: { Authorization: `Bearer ${accessToken}` },
    };
  }
}

export default ApiService;
