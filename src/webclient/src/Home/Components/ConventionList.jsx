import ConventionItem from "./ConventionItem";
import ApiService from "../../Services/ApiService";
import Loader from "../../Components/Loader";
import { useInfiniteQuery } from "@tanstack/react-query";
import { useEffect, useMemo } from "react";
import { useInView } from "react-intersection-observer";

export default function ConventionList({ searchInfo }) {
  const apiService = new ApiService(import.meta.env.VITE_API_URL);
  const [ref, inView] = useInView({
    triggerOnce: true,
  });

  async function fetchConventions({ pageParam = 1 }) {
    searchInfo.page = pageParam;
    const response = await apiService.getConventions(searchInfo);
    return response;
  }

  function handleNextPageParam(lastPage, pages) {
    return lastPage.currentPage === lastPage.totalPages
      ? undefined
      : lastPage.currentPage + 1;
  }

  function getQueryKey(searchInfo) {
    return `${searchInfo.search}-${searchInfo.lat}-${searchInfo.lon}-${searchInfo.orderBy}`;
  }

  const {
    data,
    error,
    fetchNextPage,
    hasNextPage,
    isFetching,
    isFetchingNextPage,
    status,
    isLoading,
  } = useInfiniteQuery({
    queryKey: [getQueryKey(searchInfo)],
    queryFn: fetchConventions,
    getNextPageParam: handleNextPageParam,
  });

  useEffect(() => {
    if (inView && hasNextPage) {
      fetchNextPage();
    }
  }, [inView, fetchNextPage]);

  const conventions = useMemo(() => {
    return data?.pages.reduce((acc, page) => {
      return [...acc, ...page.conventions];
    }, []);
  }, [data]);

  if (isLoading)
    return (
      <div style={{ display: "flex", justifyContent: "center" }}>
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
