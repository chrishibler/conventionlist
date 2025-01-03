using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NetTopologySuite.Geometries;

#nullable disable

namespace ConventionList.Repository.Migrations
{
    /// <inheritdoc />
    public partial class NewMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            _ = migrationBuilder
                .AlterDatabase()
                .Annotation("Npgsql:PostgresExtension:postgis", ",,");

            migrationBuilder.CreateTable(
                name: "Conventions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    SubmitterId = table.Column<string>(type: "text", nullable: true),
                    Category = table.Column<string>(type: "text", nullable: true),
                    ExternalId = table.Column<string>(type: "text", nullable: true),
                    ExternalSource = table.Column<string>(type: "text", nullable: true),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: true),
                    StartDate = table.Column<DateTime>(
                        type: "timestamp with time zone",
                        nullable: false
                    ),
                    EndDate = table.Column<DateTime>(
                        type: "timestamp with time zone",
                        nullable: false
                    ),
                    WebsiteAddress = table.Column<string>(type: "text", nullable: true),
                    VenueName = table.Column<string>(type: "text", nullable: true),
                    Address1 = table.Column<string>(type: "text", nullable: true),
                    Address2 = table.Column<string>(type: "text", nullable: true),
                    City = table.Column<string>(type: "text", nullable: true),
                    State = table.Column<string>(type: "text", nullable: true),
                    PostalCode = table.Column<string>(type: "text", nullable: true),
                    Country = table.Column<string>(type: "text", nullable: true),
                    Position = table.Column<Point>(type: "geometry", nullable: true),
                    IsApproved = table.Column<bool>(type: "boolean", nullable: false),
                    Editor = table.Column<string>(type: "text", nullable: false),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Conventions", x => x.Id);
                }
            );

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_City",
                table: "Conventions",
                column: "City"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_IsApproved",
                table: "Conventions",
                column: "IsApproved"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_Name",
                table: "Conventions",
                column: "Name"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_StartDate",
                table: "Conventions",
                column: "StartDate"
            );

            migrationBuilder.CreateIndex(
                name: "IX_Conventions_VenueName",
                table: "Conventions",
                column: "VenueName"
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            _ = migrationBuilder.DropTable(name: "Conventions");
        }
    }
}
