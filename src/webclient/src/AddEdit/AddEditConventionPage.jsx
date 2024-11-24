import { useForm } from "react-hook-form";
import { useAuth0 } from "@auth0/auth0-react";
import { useNavigate, useLocation } from "react-router-dom";
import "./AddEditConventionPage.css";
import Page from "../Components/Page";
import ApiService from "../Services/ApiService";

export default function AddEditConventionPage() {
  const navigate = useNavigate();
  const location = useLocation();
  let convention = location.state ? location.state.convention : null;
  const apiService = new ApiService(import.meta.env.VITE_API_URL);
  const { getAccessTokenSilently } = useAuth0();
  const {
    register,
    formState: { errors, isSubmitSuccessful },
    handleSubmit,
  } = useForm({
    defaultValues: {
      name: convention ? convention.name : "",
      description: convention ? convention.description : "",
      startDate: convention
        ? new Date(convention.startDate).toISOString().substring(0, 10)
        : "",
      endDate: convention
        ? new Date(convention.endDate).toISOString().substring(0, 10)
        : "",
      websiteAddress: convention ? convention.websiteAddress : null,
      venueName: convention ? convention.venueName : null,
      address1: convention ? convention.address1 : null,
      address2: convention ? convention.address2 : null,
      city: convention ? convention.city : null,
      postalCode: convention ? convention.postalCode : null,
      country: "US",
    },
  });

  async function onSubmit(data) {
    try {
      let accessToken = await getAccessTokenSilently();
      if (convention) {
        data.id = convention.id;
        await apiService.putConvention(data, accessToken);
      } else {
        await apiService.postConvention(data, accessToken);
      }

      navigate("/manage");
    } catch (err) {
      console.error(err);
      throw err;
    }
  }

  return (
    <Page>
      <div className="add-edit-form-title">
        {convention == null ? "Add Convention" : "Edit Convention"}
      </div>
      <form onSubmit={handleSubmit(onSubmit)} autoComplete="off">
        <fieldset disabled={isSubmitSuccessful}>
          <div className="form-group">
            <label htmlFor="name">Name:*</label>
            <input
              className="add-form-input"
              type="text"
              {...register("name", { required: true, maxLength: 100 })}
            />
            {errors.name && <span className="error">Name is required</span>}
          </div>
          <div className="form-group">
            <label htmlFor="description">Description:</label>
            <textarea className="add-form-input" {...register("description")} />
          </div>
          <div className="form-group">
            <label htmlFor="startDate">Start Date:*</label>
            <input
              className="add-form-input"
              type="date"
              {...register("startDate", { required: true })}
            />
            {errors.startDate && (
              <span className="error">Start date is required</span>
            )}
          </div>
          <div className="form-group">
            <label htmlFor="endDate">End Date:*</label>
            <input
              className="add-form-input"
              type="date"
              {...register("endDate", { required: true })}
            />
            {errors.endDate && (
              <span className="error">End date is required</span>
            )}
          </div>
          <div className="form-group">
            <label htmlFor="websiteAddress">URL:</label>
            <input
              className="add-form-input"
              type="text"
              {...register("websiteAddress")}
            />
          </div>
          <div className="form-group">
            <label htmlFor="venueName">Venue Name:</label>
            <input
              className="add-form-input"
              type="text"
              {...register("venueName")}
            />
          </div>
          <div className="form-group">
            <label htmlFor="address1">Address 1:</label>
            <input
              className="add-form-input"
              type="text"
              {...register("address1")}
            />
          </div>
          <div className="form-group">
            <label htmlFor="address2">Address 2:</label>
            <input
              className="add-form-input"
              type="text"
              {...register("address2")}
            />
          </div>
          <div className="form-group">
            <label htmlFor="city">City:*</label>
            <input
              className="add-form-input"
              type="text"
              {...register("city", { required: true })}
            />
            {errors.city && <span className="error">City is required</span>}
          </div>
          <div className="form-group">
            <label htmlFor="city">Postal Code:*</label>
            <input
              className="add-form-input"
              type="text"
              {...register("postalCode", { required: true })}
            />
            {errors.postalCode && (
              <span className="error">Postal code is required</span>
            )}
          </div>
          <div className="form-group">
            <label htmlFor="country">Country:*</label>
            <input
              className="add-form-input"
              type="text"
              {...register("country", { required: true })}
            />
            {errors.country && (
              <span className="error">Country is required</span>
            )}
          </div>
          <button type="submit">Submit</button>
        </fieldset>
      </form>
    </Page>
  );
}
