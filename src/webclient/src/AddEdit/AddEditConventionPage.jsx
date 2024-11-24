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
          <FormField label="name" displayLabel="Name:*" required={true} />
          <div className="form-group">
            <label htmlFor="description">Description:</label>
            <textarea className="add-form-input" {...register("description")} />
          </div>
          <FormField
            label="startDate"
            displayLabel="Start Date:*"
            type="date"
            required={true}
          />
          <FormField
            label="endDate"
            displayLabel="End Date:*"
            type="date"
            required={true}
          />
          <FormField
            label="websiteAddress"
            displayLabel="Website Address:"
            required={true}
          />
          <FormField
            label="venueName"
            displayLabel="Venue Name:"
            required={false}
          />
          <FormField
            label="address1"
            displayLabel="Address:"
            required={false}
          />
          <FormField
            label="address2"
            displayLabel="Address2:"
            required={false}
          />
          <FormField label="city" displayLabel="City:*" required={true} />
          <FormField
            label="postalCode"
            displayLabel="Postal Code*"
            isRequired={true}
          />
          <FormField
            label="country"
            displayLabel="Country*"
            isRequired={true}
          />
          <button type="submit">Submit</button>
        </fieldset>
      </form>
    </Page>
  );

  function FormField(props) {
    let type = props.type === undefined ? "text" : props.type;
    return (
      <div className="form-group">
        <label htmlFor={props.label}>{props.displayLabel}</label>
        <input
          className="add-form-input"
          type={type}
          {...register(props.label, { required: props.isRequired })}
        />
        {errors[props.label] && (
          <span className="error">{props.displayLabel} is required</span>
        )}
      </div>
    );
  }
}
