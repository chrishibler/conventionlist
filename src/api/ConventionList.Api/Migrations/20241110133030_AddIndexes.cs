using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ConventionList.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddIndexes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Conventions_City",
                table: "Conventions",
                column: "City");

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_Name",
                table: "Conventions",
                column: "Name");

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_StartDate",
                table: "Conventions",
                column: "StartDate");

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_VenueName",
                table: "Conventions",
                column: "VenueName");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Conventions_City",
                table: "Conventions");

            migrationBuilder.DropIndex(
                name: "IX_Conventions_Name",
                table: "Conventions");

            migrationBuilder.DropIndex(
                name: "IX_Conventions_StartDate",
                table: "Conventions");

            migrationBuilder.DropIndex(
                name: "IX_Conventions_VenueName",
                table: "Conventions");
        }
    }
}
