class NativeObjectsController < ApplicationController
    before_action :set_native_object, only: %i[ show edit update destroy ]

    def index
        @native_objects = NativeObject.all
    end

    def show
    end

    # GET /posts/new
    def new
      @native_objects = NativeObject.new
    end

    # GET /posts/1/edit
    def edit
    end

    # POST /posts or /posts.json
    def create
      @native_object = NativeObject.new(native_object_params)

      respond_to do |format|
        if @native_object.save
          format.html { redirect_to @native_object, notice: "Post was successfully created." }
          format.json { render :show, status: :created, location: @native_object }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @native_object.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /posts/1 or /posts/1.json
    def update
      respond_to do |format|
        if @native_object.update(native_object_params)
          format.html { redirect_to @native_object, notice: "Post was successfully updated." }
          format.json { render :show, status: :ok, location: @native_object }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @native_object.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /posts/1 or /posts/1.json
    def destroy
      @native_object.destroy!

      respond_to do |format|
        format.html { redirect_to native_objects_path, status: :see_other, notice: "Post was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def delete_all
      NativeObject.destroy_all
      respond_to do |format|
        format.html { redirect_to native_objects_path, status: :see_other, notice: "All posts were successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_native_object
        @native_object = NativeObject.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def native_object_params
        params.expect(post: [ :title, :body ])
      end
end
