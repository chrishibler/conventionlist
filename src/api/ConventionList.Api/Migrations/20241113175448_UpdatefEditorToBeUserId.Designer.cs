﻿// <auto-generated />
using System;
using ConventionList.Api.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using NetTopologySuite.Geometries;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace ConventionList.Api.Migrations
{
    [DbContext(typeof(ConventionListDbContext))]
    [Migration("20241113175448_UpdatefEditorToBeUserId")]
    partial class UpdatefEditorToBeUserId
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.3")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.HasPostgresExtension(modelBuilder, "postgis");
            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("ConventionList.Api.Models.Convention", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uuid");

                    b.Property<string>("Address1")
                        .HasColumnType("text");

                    b.Property<string>("Address2")
                        .HasColumnType("text");

                    b.Property<string>("Category")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("City")
                        .HasColumnType("text");

                    b.Property<string>("Country")
                        .HasColumnType("text");

                    b.Property<string>("Description")
                        .HasColumnType("text");

                    b.Property<string>("Editor")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<DateTime>("EndDate")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("ExternalId")
                        .HasColumnType("text");

                    b.Property<string>("ExternalSource")
                        .HasColumnType("text");

                    b.Property<bool>("IsApproved")
                        .HasColumnType("boolean");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<Point>("Position")
                        .HasColumnType("geometry");

                    b.Property<string>("PostalCode")
                        .HasColumnType("text");

                    b.Property<DateTime>("StartDate")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("State")
                        .HasColumnType("text");

                    b.Property<string>("SubmitterId")
                        .HasColumnType("text");

                    b.Property<string>("VenueName")
                        .HasColumnType("text");

                    b.Property<string>("WebsiteAddress")
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("City");

                    b.HasIndex("IsApproved");

                    b.HasIndex("Name");

                    b.HasIndex("StartDate");

                    b.HasIndex("VenueName");

                    b.ToTable("Conventions");
                });
#pragma warning restore 612, 618
        }
    }
}
