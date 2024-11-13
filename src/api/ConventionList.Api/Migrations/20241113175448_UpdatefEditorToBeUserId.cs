using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ConventionList.Api.Migrations
{
    /// <inheritdoc />
    public partial class UpdatefEditorToBeUserId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Edited",
                table: "Conventions");

            migrationBuilder.AddColumn<string>(
                name: "Editor",
                table: "Conventions",
                type: "text",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Editor",
                table: "Conventions");

            migrationBuilder.AddColumn<bool>(
                name: "Edited",
                table: "Conventions",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }
    }
}
