using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ConventionList.Api.Migrations
{
    /// <inheritdoc />
    public partial class RemoveUserRole : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Conventions_Users_SubmitterId",
                table: "Conventions");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropIndex(
                name: "IX_Conventions_SubmitterId",
                table: "Conventions");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<string>(type: "text", nullable: false),
                    Role = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_SubmitterId",
                table: "Conventions",
                column: "SubmitterId");

            migrationBuilder.AddForeignKey(
                name: "FK_Conventions_Users_SubmitterId",
                table: "Conventions",
                column: "SubmitterId",
                principalTable: "Users",
                principalColumn: "Id");
        }
    }
}
