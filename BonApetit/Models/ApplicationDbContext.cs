﻿using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Security.Claims;

namespace BonApetit.Models
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public DbSet<Recipe> Recipes { get; set; }
        public DbSet<Ingredient> Ingredients { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Image> Images { get; set; }

        public ApplicationDbContext()
            : base("DefaultConnection", throwIfV1Schema: false)
        {
        }

        public static ApplicationDbContext Create()
        {
            return new ApplicationDbContext();
        }

        public ApplicationUser GetUser(string id)
        {
            return this.Users.FirstOrDefault(u => u.Id == id);
        }

        public void AddRecipe(Recipe recipe)
        {
            var recipeAlreadyExists = this.Recipes.Any(r => r.Id == recipe.Id || r.Name == recipe.Name);
            if (recipeAlreadyExists)
                throw new ArgumentException("The given recipe already exists.");

            this.Recipes.Add(recipe);
        }

        public Recipe GetRecipe(Guid id)
        {
            var recipe = this.Recipes.Find(id);
            return recipe;
        }

        public IQueryable<Recipe> GetRecipes(string categoryName = null, bool favouritesOnly = false)
        {
            if (favouritesOnly)
            {
                var principal = ClaimsPrincipal.Current;
                var userId = principal.FindFirst(ClaimTypes.NameIdentifier).Value;
                var user = this.GetUser(userId);

                if (categoryName != null)
                    return user.FavouriteRecipes.Where(r => r.Categories.Any(c => c.Name == categoryName)).AsQueryable();
                else
                    return user.FavouriteRecipes.AsQueryable();
            }
            else
            {
                if (categoryName != null)
                    return this.Recipes.Where(r => r.Categories.Any(c => c.Name == categoryName));
                else
                    return this.Recipes;
            }
        }

        public void DeleteRecipe(Guid id)
        {
            var recipe = this.GetRecipe(id);
            if (recipe != null)
            {
                if (recipe.Image != null)
                {
                    this.DeleteImage(recipe.Image);
                }

                if (recipe.Ingredients != null)
                {
                    this.Ingredients.RemoveRange(recipe.Ingredients);
                }

                this.Recipes.Remove(recipe);
            }
        }

        private void DeleteImage(Image image)
        { 
            this.Images.Remove(image);
        }

        public IQueryable<Category> GetCategories()
        {
            return this.Categories;
        }

        public Category GetCategory(Guid id)
        {
            return this.Categories.FirstOrDefault(c => c.Id == id);
        }

        public void AddCategory(string name)
        {
            var category = new Category(name);
            this.AddCategory(category);
        }

        public void AddCategory(Category category)
        {
            this.Categories.Add(category);
        }

        public void Delete(Ingredient ingredient)
        {
            this.Ingredients.Remove(ingredient);
        }

        public void Delete(IEnumerable<Ingredient> ingredient)
        {
            this.Ingredients.RemoveRange(ingredient);
        }

        public override int SaveChanges()
        {
            var deletedImagesUrls = this.ChangeTracker.Entries<Image>().Where(i => i.State == EntityState.Deleted).Select(i => i.Entity.ImageUrl);
            foreach (var url in deletedImagesUrls)
            {
                // Delete image from FS
            }

            return base.SaveChanges();
        }
    }
}