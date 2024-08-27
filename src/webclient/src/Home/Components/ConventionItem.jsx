import ConventionDetails from "./ConventionDetails";
import ConventionName from "./ConventionName";

export default function ConventionItem({ convention, index }) {
  const isOdd = index % 2 === 1;

  return (
    <div
      className={
        isOdd
          ? "convention-item-container convention-item-container-odd"
          : "convention-item-container"
      }
    >
      <ConventionName
        conventionName={convention.name}
        conventionUrl={convention.websiteAddress}
      />
      <ConventionDetails convention={convention} />
    </div>
  );
}
