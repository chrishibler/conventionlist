import PropTypes from "prop-types";
import { Commet } from "react-loading-indicators";

export default function Loader({ size }) {
  return <Commet color="#a6e3a1" size={size} text="" textColor="" />;
}

Loader.propTypes = {
  size: PropTypes.number,
};
