import { useInView } from "react-intersection-observer";
import { useInfiniteQuery } from "@tanstack/react-query";
import { useEffect, useMemo, useReducer, useContext } from "react";
import { useAuth0 } from "@auth0/auth0-react";
import { Edit, Trash2 } from "react-feather";
import { useNavigate } from "react-router-dom";
import { ApiServiceContext } from "../Services/ApiService";
import Loader from "../Components/Loader";
import Page from "../Components/Page";
import "./ManageConventionsPage.css";

export default function ManageConventionsPage() {
  const navigate = useNavigate();
  const { getAccessTokenSilently } = useAuth0();
  const [, forceUpdate] = useReducer((x) => x + 1, 0);
  const apiService = useContext(ApiServiceContext);
  const [ref, inView] = useInView({
    triggerOnce: true,
  });

  async function fetchConventions({ pageParam = 1 }) {
    let accessToken = await getAccessTokenSilently();
    const response = await apiService.getUserConventions(
      accessToken,
      pageParam
    );
    return response;
  }

  async function deleteConvention(id) {
    let accessToken = await getAccessTokenSilently();
    await apiService.deleteConvention(id, accessToken);
    let conToRemove = conventions.find((c) => c.id === id);
    let index = conventions.indexOf(conToRemove);
    conventions.splice(index, 1);
    forceUpdate();
  }

  async function editConvention(convention) {
    navigate("/edit", { state: { convention: convention } });
  }

  function handleNextPageParam(lastPage) {
    return lastPage.conventions.length < apiService.pageSize
      ? undefined
      : lastPage.currentPage + 1;
  }

  const { data, error, fetchNextPage, hasNextPage, isLoading } =
    useInfiniteQuery({
      queryKey: ["user/conventions"],
      queryFn: fetchConventions,
      getNextPageParam: handleNextPageParam,
    });

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

  if (error) {
    console.error(error);
  }

  if (error)
    return (
      <div>
        <h3>Uh oh! An error occurred.</h3>
      </div>
    );

  return (
    <Page>
      <table>
        <thead>
          <tr>
            <th className="table-header">Name</th>
            <th className="table-header">Start</th>
            <th className="table-header">End</th>
            <th className="table-header">Venue</th>
            <th className="table-header">City</th>
          </tr>
        </thead>
        <tbody>
          {conventions.map((convention, index) => (
            <tr
              ref={ref}
              key={index}
              className={index % 2 === 0 ? "convention-row-odd" : ""}
            >
              <td>{convention.name}</td>
              <td>{new Date(convention.startDate).toLocaleDateString()}</td>
              <td>{new Date(convention.endDate).toLocaleDateString()}</td>
              <td>{convention.venueName}</td>
              <td>{convention.city}</td>
              <td>
                <button
                  className="delete-button"
                  onClick={() => deleteConvention(convention.id)}
                >
                  <Trash2 />
                </button>
              </td>
              <td>
                <button
                  className="delete-button"
                  onClick={() => editConvention(convention)}
                >
                  <Edit />
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </Page>
  );
}
