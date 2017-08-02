defmodule Commercefacile.Ads.Ad do
    use Ecto.Schema
    import Ecto.Changeset

    # use Rummage.Ecto

    @default_duration [months: 1]

    @private %{
        title: :string, 
        condition: :string, 
        description: :string, 
        price: :string, 
        negotiable: :boolean, 
        category: :string, 
        images: {:array, :string}
    }
    @guest %{
        name: :string,
        phone: :string,
        password: :string,
        password_confirmation: :string,
        location: :string
    }

    schema "ads" do
        field :uuid, :string
        field :code, :string
        
        field :title, :string
        field :condition, :string
        field :description, :string
        field :price, :string
        field :negotiable, :boolean
        field :status, :string

        field :start_date, :utc_datetime
        field :end_date, :utc_datetime        

        belongs_to :user, Commercefacile.Accounts.User
        belongs_to :category, Commercefacile.Ads.Category
        has_many :images, Commercefacile.Ads.Images, on_delete: :delete_all
        has_one :rejected, Commercefacile.Ads.Rejected, on_delete: :delete_all
        many_to_many :reporters, Commercefacile.Accounts.User, join_through: "reported_ads", on_delete: :delete_all
        many_to_many :favoriters, Commercefacile.Accounts.User, join_through: "favorited_ads", on_delete: :delete_all

        timestamps()
    end

    def changeset(struct, %{} = params \\ %{}) do
        struct
        |> cast(params, [:start_date, :end_date, :code, :status, :title, :condition, :description, :price, :negotiable, :user_id, :category_id])
        |> validate_required([:title, :condition, :description, :price, :negotiable, :user_id, :category_id])
    end

    def add_pending_status(changeset) do
        put_change(changeset, :status, "pending")
    end

    def add_uuid(changeset) do
        put_change(changeset, :uuid, Ksuid.generate())
    end

    def add_start_and_end_date(changeset) do
        start_date = Timex.now
        end_date = Timex.shift(start_date, @default_duration)
        changeset
        |> put_change(:start_date, start_date)
        |> put_change(:end_date, end_date)
    end

    def form_changeset(params \\ %{}, private_or_guest)
    def form_changeset(params, :private) do
        data = %{}
        type = @private
        optional = %{location: :string}

        {data, Map.merge(type, optional)}
        |> cast(params, Map.keys(Map.merge(type, optional)))
        |> validate_required(Map.keys(type))
        |> validate_length(:title, min: 5)
        |> validate_length(:description, min: 10)
        |> validate_length(:images, min: 1)
    end
    def form_changeset(params, :private_with_location) do
        form_changeset(params, :private)
        |> validate_required([:location])
    end
    def form_changeset(params, :guest) do
        data = %{}
        type = Map.merge(@private, @guest)

        {data, type}
        |> cast(params, Map.keys(type))
        |> validate_required(Map.keys(type))
        |> validate_length(:title, min: 5)
        |> validate_length(:description, min: 10)
        |> validate_length(:images, min: 1)
        |> format_phone
        |> validate_length(:phone, is: 11)
        |> validate_length(:password, min: 7)
        |> validate_confirmation(:password)
    end

    defp format_phone(changeset) do
        phone = get_change(changeset, :phone)
        if phone do
            phone = String.replace(phone, " ", "")
            put_change(changeset, :phone, phone)
        else
            changeset
        end
    end
end