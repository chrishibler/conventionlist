using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ConventionList.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddIsApprovedToConvention : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsApproved",
                table: "Conventions",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsApproved",
                table: "Conventions");
        }
    }
}
