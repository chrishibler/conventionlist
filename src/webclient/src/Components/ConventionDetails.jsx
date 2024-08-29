import PropTypes from "prop-types";
import Description from "./Description";

export default function ConventionDetails({ convention }) {
  return (
    <div className="details">
      <div>
        <strong>
          <em>
            {new Date(convention.startDate).toLocaleDateString()} -{" "}
            {new Date(convention.endDate).toLocaleDateString()}
          </em>
        </strong>
      </div>
      {convention.venuName && <div>{convention.venuName}</div>}
      {convention.city && (
        <div>
          {convention.city} {convention.state && `, ${convention.state}`}
        </div>
      )}
      <Description description={convention.description} />
    </div>
  );
}

ConventionDetails.propTypes = {
  convention: PropTypes.object,
};
