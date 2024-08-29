export default function ConventionName({ conventionName, conventionUrl }) {
  return conventionUrl ? (
    <a
      className="convention-name convention-name-link"
      href={conventionUrl}
      target="_blank"
      rel="noreferrer"
    >
      {conventionName}
    </a>
  ) : (
    <div className="convention-name">{conventionName}</div>
  );
}
