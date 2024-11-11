using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ConventionList.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddEditedField : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "Edited",
                table: "Conventions",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_IsApproved",
                table: "Conventions",
                column: "IsApproved");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Conventions_IsApproved",
                table: "Conventions");

            migrationBuilder.DropColumn(
                name: "Edited",
                table: "Conventions");
        }
    }
}
