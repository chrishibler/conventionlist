import "./AddEditConventionForm.css";
import { useForm } from "react-hook-form";
import ApiService from "../Services/ApiService";

export default function AddEditConventionForm() {
  const apiService = new ApiService(import.meta.env.VITE_API_URL);
  const {
    register,
    formState: { errors },
    handleSubmit,
  } = useForm({
    defaultValues: { country: "US" },
  });

  function onSubmit(data) {
    apiService.postConvention(data);
  }

  return (
    <div>
      <div className="add-edit-form-title">Add Convention</div>
      <form onSubmit={handleSubmit(onSubmit)}>
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
          {errors.country && <span className="error">Country is required</span>}
        </div>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
}
