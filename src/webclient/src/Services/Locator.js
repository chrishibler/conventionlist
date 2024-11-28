import { createContext } from "react";

export const LocatorContext = createContext(null);

export default class Locator {
  getLocation() {
    const options = {
      maximumAge: 0, // Ensures that the browser doesn't return a cached location
    };
    return new Promise((resolve, reject) => {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            const userLocation = {
              latitude: position.coords.latitude,
              longitude: position.coords.longitude,
            };
            resolve(userLocation);
          },
          (error) => {
            reject(error);
          },
          options
        );
      } else {
        reject("Geolocation is not supported by this browser.");
      }
    });
  }
}
