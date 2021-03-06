﻿<%@ Page Title="Edit recipe" MasterPageFile="~/Site.Master"  Language="C#" AutoEventWireup="true" CodeBehind="ManageRecipe.aspx.cs" Inherits="BonApetit.Recipes.ManageRecipe" %>

<%@ Register TagPrefix="uc" TagName="DynamicTextBox"  Src="~/Controls/Forms/DynamicTextBox.ascx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
        <p class="alert alert-danger">
            <asp:Literal runat="server" ID="FailureText" />
        </p>
    </asp:PlaceHolder>

    <asp:FormView runat="server" ID="EditForm" ItemType="BonApetit.Models.Recipe" SelectMethod="EditForm_GetItem" RenderOuterTable="false">
        <EmptyDataTemplate>
            <div class="alert alert-danger">The recipe wasn't found.</div>
        </EmptyDataTemplate>
        <ItemTemplate>
            <div class="row">
                <div class="col-md-8">
                    <section id="recipeForm">
                        <div class="horizontal">
                            <div class="form-group">
                                <asp:Label runat="server" AssociatedControlID="Name" CssClass="col-md-2 control-label">Name</asp:Label>
                                <div class="col-md-10">
                                    <asp:TextBox runat="server" ID="Name" CssClass="form-control" TextMode="SingleLine" Text=<%#: Item.Name %> />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Name"
                                        CssClass="text-danger" ErrorMessage="The name field is required." />
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label runat="server" AssociatedControlID="Description" CssClass="col-md-2 control-label">Description</asp:Label>
                                <div class="col-md-10">
                                    <asp:TextBox runat="server" ID="Description" TextMode="MultiLine" CssClass="form-control" Text=<%#: Item.Description %> />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Description" CssClass="text-danger" ErrorMessage="The description field is required." />
                                </div>
                            </div>
                            <uc:DynamicTextBox ID="Ingredients" runat="server" Title="Ingredients" OnDataBinding="Ingredients_DataBinding" />
                            <div class="form-group">
                                <asp:Label runat="server" AssociatedControlID="PreparationInstructions" CssClass="col-md-2 control-label">Preparation instructions</asp:Label>
                                <div class="col-md-10">
                                    <asp:TextBox runat="server" ID="PreparationInstructions" TextMode="MultiLine" CssClass="form-control" Text=<%#: Item.PrepareInstructions %> />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="PreparationInstructions" CssClass="text-danger" ErrorMessage="The preparation instructions field is required." />
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label runat="server" AssociatedControlID="CategoriesList" CssClass="col-md-2 control-label">Categories</asp:Label>
                                <div class="col-md-10">
                                    <asp:ListBox CssClass="selectpicker" runat="server" ID="CategoriesList" SelectMethod="GetCategories" ItemType="BonApetit.Models.Category"
                                        DataTextField="Name" DataValueField="Id" AppendDataBoundItems="false" AutoPostBack="false" SelectionMode="Multiple" OnDataBound="CategoriesList_DataBound">
                                    </asp:ListBox><br />
                                    or add new category:
                                    <div class="input-group">
                                        <asp:TextBox ID="NewCategory" runat="server" CssClass="form-control" />
                                        <span class="input-group-btn">
                                            <asp:Button ID="NewCategoryButton" CssClass="btn btn-default" runat="server" Text="Add Category" OnClick="NewCategoryButton_Click" CausesValidation="false" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label runat="server" AssociatedControlID="ImageUpload" CssClass="col-md-2 control-label">Image</asp:Label>
                                <div class="col-md-10">
                                    <asp:Image runat="server" CssClass="thumbnail" ImageUrl=<%#: ResolveUrl("~/Recipes/Images/" + Item.Image.ImageUrl) %> />
                                    <asp:FileUpload CssClass="filestyle" runat="server" ID="ImageUpload" data-buttonBefore="true" />               
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-md-offset-2 col-md-10">
                                    <asp:Button runat="server" OnClick="SaveRecipe" Text="Save" CssClass="btn btn-default" />
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>

            <%: Scripts.Render("~/bundles/filestyle") %>
            <%: Styles.Render("~/Content/bootstrapselect") %>
        </ItemTemplate>
    </asp:FormView>
</asp:Content>
