class LinksController < ApplicationController
    before_action :set_link, only: [:edit, :update, :show, :destory]
    before_action :authenticate_user!, expect: [:index, :show]
    before_action :authorized_user, only: [:edit, :update, :destory]
    
    def index
        @links = Link.all
    end 

    def show 
    end 

    def new
        @link = current_user.links.build
    end 

    def edit 
    end 

    def create 
        @link = current_user.links.build(link_params)
        respond_to do |format|
            if @link.save
              format.html { redirect_to @link, notice: 'Link was successfully created.' }
              format.json { render :show, status: :created, location: @link }
            else
              format.html { render :new }
              format.json { render json: @link.errors, status: :unprocessable_entity }
            end
        end
    end 

    def update
        respond_to do |format|
          if @link.update(link_params)
            format.html { redirect_to @link, notice: 'Link was successfully updated.' }
            format.json { render :show, status: :ok, location: @link }
          else
            format.html { render :edit }
            format.json { render json: @link.errors, status: :unprocessable_entity }
          end
        end
      end
    
      # DELETE /links/1
      # DELETE /links/1.json
      def destroy
        @link.destroy
        respond_to do |format|
          format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      def upvote
        @link = Link.find(params[:id])  
        @link.upvote_by current_user
      
        redirect_to links_url
      end
      
      def downvote
        @link = Link.find(params[:id])
        @link.downvote_by current_user
      
        redirect_to links_url
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_link
          @link = Link.find(params[:id])
        end
    
        def authorized_user
          @link = current_user.links.find_by(id: params[:id])
          redirect_to links_path, notice: "Not authorized to edit this link" if @link.nil?
        end
    
        # Never trust parameters from the scary internet, only allow the white list through.
        def link_params
          params.require(:link).permit(:title, :url)
        end

end
