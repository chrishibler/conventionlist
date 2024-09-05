import { withAuthenticationRequired } from "@auth0/auth0-react";

export default function ProtectedRoute({ component, ...args }) {
  const ProtectedComponent = withAuthenticationRequired(component, args);
  return <ProtectedComponent />;
}
