import { useState } from "react";
import Select from "react-select";
import { ArrowDown } from "react-feather";

export default function OrderBy({ onOrderByChanged }) {
  const defaultOption = { value: "startdate", label: "Start Date" };
  const [selectedOption, setSelectedOption] = useState(defaultOption);
  const options = [defaultOption, { value: "distance", label: "Distance" }];

  function CustomSingleValue({ innerProps, isDisabled }) {
    return (
      <div style={{ marginBottom: "10px", marginLeft: "8px" }}>
        <ArrowDown color="#cdd6f4" />
      </div>
    );
  }

  return (
    <Select
      components={{
        SingleValue: CustomSingleValue,
        DropdownIndicator: () => null,
        IndicatorSeparator: () => null,
      }}
      className="orderby"
      value={selectedOption}
      isSearchable={false}
      options={options}
      onChange={(option) => {
        setSelectedOption(option);
        onOrderByChanged(option.value);
      }}
      styles={{
        control: (baseStyles, state) => ({
          ...baseStyles,
          borderColor: state.isFocused ? "#89b4fa" : "#313244",
          borderWidth: "1px",
          backgroundColor: "transparent",
          width: "60px",
          color: "#cdd6f4",
        }),
        option: (provided, state) => ({
          ...provided,
          borderWidth: "1px",
          borderRadius: "10px",
          backgroundColor: "transparent",
          color: "#cdd6f4",
          width: "200px",
          ":hover": { backgroundColor: "#45475a" },
        }),
        singleValue: (provided, state) => ({
          ...provided,
          // color: "#cdd6f4",
        }),
        menu: (base) => ({
          ...base,
          width: "216px",
          borderStyle: "none",
          backgroundColor: "#313244",
          // backgroundColor: "orange",
        }),
        menuList: (base) => ({
          ...base,
          backgroundColor: "transparent",
        }),
      }}
    />
  );
}
