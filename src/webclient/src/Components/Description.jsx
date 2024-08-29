import React, { useState } from "react";
import { useMediaQuery } from "@uidotdev/usehooks";

export default function Description({ description }) {
  const [isCollapsed, setIsCollapsed] = useState(true);

  const isMediumDevice = useMediaQuery(
    "only screen and (min-width : 769px) and (max-width : 992px)"
  );
  const isLargeDevice = useMediaQuery(
    "only screen and (min-width : 993px) and (max-width : 1200px)"
  );
  const isExtraLargeDevice = useMediaQuery(
    "only screen and (min-width : 1201px)"
  );

  let maxCharacters = 100;
  if (isMediumDevice) {
    maxCharacters = 200;
  } else if (isLargeDevice) {
    maxCharacters = 300;
  } else if (isExtraLargeDevice) {
    maxCharacters = 400;
  }

  if (!description) {
    return "";
  }

  return (
    <div
      className="convention-description"
      onClick={() => setIsCollapsed((value) => !value)}
    >
      {isCollapsed && description.length > maxCharacters ? (
        <span>
          {description.substring(0, maxCharacters)}
          <span>...</span>
          <div>
            <strong>READ MORE</strong>
          </div>
        </span>
      ) : (
        <span>
          {description}
          {description.length > maxCharacters && (
            <div>
              <strong>READ LESS</strong>
            </div>
          )}
        </span>
      )}
    </div>
  );
}
