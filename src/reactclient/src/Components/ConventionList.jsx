import { useInfiniteQuery } from "@tanstack/react-query";
import { useEffect, useMemo, useContext, useState } from "react";
import { useInView } from "react-intersection-observer";
import "./ConventionList.css";
import PropTypes from "prop-types";
import ConventionItem from "./ConventionItem";
import { ApiServiceContext } from "../Services/ApiService";
import { LocatorContext } from "../Services/Locator";
import Loader from "./Loader";

export default function ConventionList({ searchInfo }) {
  const apiService = useContext(ApiServiceContext);
  const [location, setLocation] = useState();
  const locator = useContext(LocatorContext);
  const [ref, inView] = useInView({
    triggerOnce: true,
  });

  async function fetchConventions({ pageParam = 1 }) {
    searchInfo.page = pageParam;
    searchInfo.lat = location ? location.latitude : null;
    searchInfo.lon = location ? location.longitude : null;
    const response = await apiService.getConventions(searchInfo);
    return response;
  }

  function handleNextPageParam(lastPage) {
    return lastPage.conventions.length < apiService.pageSize
      ? undefined
      : lastPage.currentPage + 1;
  }

  function getQueryKey(searchInfo) {
    return `${searchInfo.search}-${searchInfo.lat}-${searchInfo.lon}-${searchInfo.orderBy}`;
  }

  const { data, error, fetchNextPage, hasNextPage, isFetching, isLoading } =
    useInfiniteQuery({
      queryKey: [getQueryKey(searchInfo)],
      queryFn: fetchConventions,
      getNextPageParam: handleNextPageParam,
    });

  useEffect(() => {
    async function getSetLocation() {
      let location = await locator.getLocation();
      setLocation(location);
    }
    getSetLocation();
  }, [locator]);

  useEffect(() => {
    if (inView && hasNextPage) {
      fetchNextPage();
    }
  }, [inView, fetchNextPage, hasNextPage]);

  const conventions = useMemo(() => {
    return data?.pages.reduce((acc, page) => {
      return [...acc, ...page.conventions];
    }, []);
  }, [data]);

  if (isLoading)
    return (
      <div className="loader-container">
        <Loader />
      </div>
    );

  if (error)
    return (
      <div>
        <h3>Uh oh! An error occurred.</h3>
        <p>{error}</p>
      </div>
    );

  return (
    <div className="convention-list">
      {conventions.map((convention, index) => (
        <div ref={ref} key={index}>
          <ConventionItem convention={convention} index={index} />
        </div>
      ))}
      {isFetching && <Loader />}
    </div>
  );
}

ConventionList.propTypes = {
  searchInfo: PropTypes.object,
};
