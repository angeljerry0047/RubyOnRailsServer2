class SkillsController < ApplicationController

  before_filter :authenticate_user!
  autocomplete :opportunity, :title, :scopes => [:external]

  expose(:public_opportunities) { Opportunity.non_historical_active.where(internal: false).order("title")  }

  def index
    if skills_params[:organization_id].present?
     unless skills_params[:organization_id] == [""]
      @organization_id =  skills_params[:organization_id]
     end
    else
      @organization_id = nil
    end

    @competencies = Competency.where(:id => skills_params[:competency_ids])
    @category = OpportunityCategory.where(:id => skills_params[:opportunity_category_id])
    @mentors = Opportunity.where(:opportunity_category_id => 18, :organization_id => @organization_id)
    @volunteers = Opportunity.where(:opportunity_category_id => 21, :organization_id => @organization_id)
    @recommendations = Recommendation.active
    @ideas = BestPractice.where(:organization_id => @organization_id)
    @ideasPublic = BestPractice.is_public
    @pacs = Pac.where(:organization_id => @organization_id)
    @pacsPublic = Pac.view_public.where(:best_practice_category_id => nil)
    @questions = Inquiry.where(:organization_id => @organization_id)
    @questionsPublic = Inquiry.is_public
    @externs = Opportunity.where(:opportunity_category_id => 19, :organization_id => @organization_id)
    @fastContents = FastContent.where(:organization_id => @organization_id)
    @skills = (@recommendations + public_opportunities + @ideas + @pacs + @questions).sort_by{ |skill| skill.created_at }


    # FIXME (cmhobbs) extract the contents of these if blocks into private
    #       methods and then appropriate object types.  all this conditional
    #       logic smells like polymorphism to me.
    if skills_params[:zipcode] =~ /^\d{5 }(-\d{4 })?$/ && skills_params[:miles]
      @skills = public_opportunities.within(skills_params[:zipcode], skills_params[:miles])
    end

    if skills_params[:internal_only]
      @skills = public_opportunities.within_organization(current_user.organization) + @recommendations.within_organization(current_user.organization) + @ideas.within_organization(current_user.organization)
    end

    if skills_params[:public_ideas]
      @skills = @ideas
    end

    if skills_params[:public_questions]
      @skills = @questions
    end

    if skills_params[:public_pacs]
      @skills = @pacs
    end

    

    if skills_params[:current_opportunities]
      @skills = public_opportunities
    end

    if skills_params[:current_recommendations]
      @skills = @recommendations
    end    

    if !@competencies.empty?
      @skills = public_opportunities.with_competencies(@competencies)
    end

    if !@category.empty?
      @skills = (public_opportunities.with_category(OpportunityCategory.find(skills_params[:opportunity_category_id])) + @recommendations.with_category(OpportunityCategory.find(skills_params[:opportunity_category_id])))
    end

    if skills_params[:form_of_learning_id].present?
      case skills_params[:form_of_learning_id]
      when "mentor"
        @skills = @recommendations.advisor + @mentors

        if skills_params[:popular]
          @skills = @recommendations.advisor + @mentors.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = @recommendations.advisor + @mentors.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = @recommendations.advisor + @mentors.keep_if{ |i| i.trending_points > 0  }
        end

      when "idea"
        @skills = @ideas + @ideasPublic

        if skills_params[:popular]
          @skills = @ideas.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = @ideas.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = @ideas.keep_if{ |i| i.trending_points > 0  }
        end

      when "question"
        @skills = @questions + @questionsPublic

        if skills_params[:popular]
          @skills = @questions.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = @questions.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = @questions.keep_if{ |i| i.trending_points > 0  }
        end

      when "volunteer"
        @skills = @recommendations.volunteer + @volunteers

        if skills_params[:popular]
          @skills = @recommendations.volunteer + @volunteers.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = @recommendations.volunteer + @volunteers.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = @recommendations.volunteer + @volunteers.keep_if{ |i| i.trending_points > 0  }
        end

      when "coach"
        @skills = public_opportunities.coach + @recommendations.coach

        if skills_params[:popular]
          @skills = public_opportunities.coach + @recommendations.coach.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = public_opportunities.coach + @recommendations.coach.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = public_opportunities.coach + @recommendations.coach.keep_if{ |i| i.trending_points > 0  }
        end

      when "intern"
        @skills = @recommendations.intern + @externs

        if skills_params[:popular]
          @skills = @recommendations.intern + @externs.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = @recommendations.intern + @externs.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = @recommendations.intern + @externs.keep_if{ |i| i.trending_points > 0  }
        end

      when "speaker"
        @skills = public_opportunities.speaker + @recommendations.speaker

        if skills_params[:popular]
          @skills = public_opportunities.speaker + @recommendations.speaker.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = public_opportunities.speaker + @recommendations.speaker.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = public_opportunities.speaker + @recommendations.speaker.keep_if{ |i| i.trending_points > 0  }
        end

      when "pacs"
        @skills = @pacsPublic + @pacs

        if skills_params[:popular]
          @skills = @pacsPublic + @pacs.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = @pacsPublic + @pacs.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = @pacsPublic + @pacs.keep_if{ |i| i.trending_points > 0  }
        end

      when "advisor"
        @skills = public_opportunities.advisor + @recommendations.advisor

        if skills_params[:popular]
          @skills = public_opportunities.advisor + @recommendations.advisor.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = public_opportunities.advisor + @recommendations.advisor.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = public_opportunities.advisor + @recommendations.advisor.keep_if{ |i| i.trending_points > 0  }
        end

      when "fast_content"
        @skills = @fastContents

        if skills_params[:popular]
          @skills = @fastContents.keep_if{ |i| i.likes > 0 }
        end

        if skills_params[:newest]
          @skills = @fastContents.sort_by{ |i| i.updated_at }
        end

        if skills_params[:trending]
          @skills = @fastContents.keep_if{ |i| i.trending_points > 0  }
        end

      end
    end
  end

  def edit_many
    @past_opportunities = current_user.past_opportunities + current_user.deactive_recommendations
    @owned_opportunities = current_user.current_opportunities + current_user.active_recommendations
    @oppotunity_categories = OpportunityCategory.order("id")
    @oppotunity_types = OpportunityType.order("id")
    @public_ideas = current_user.best_practices
    @pacs = @current_user.all_pacs.uniq.reverse
    @action_plans = current_user.mentor_action_plans + current_user.coach_action_plans + current_user.volunteer_action_plans
  end

  def getFacilities
    opportunity = Array(skills_params.fetch(:opportunities)).first
    state       = opportunity.fetch(:state)
    city        = opportunity.fetch(:city)

    if(city=="")
      @data_for_facility = Facility.where(:state => state).all
    else
      @data_for_facility = Facility.where(:state => state, :city =>city).all
    end

    render :json => @data_for_facility.map{ |c| [c.id, c.name] }
  end

  def getAddress
    @data_for_facility = Facility.where(:id => skills_params.fetch(:facility_name_dropdown))
    render :json => @data_for_facility.map{ |c| [c.id, c.address, c.map_location, c.city, c.approval_name, c.approval_mail] }
  end

  def getPrice
    opportunity = Array(skills_params.fetch(:opportunities)).first
    @data_for_category = OpportunityCategory.where(:id => opportunity.fetch(:opportunity_category_id)).all
    render :json => @data_for_category.map{ |c| [c.id, c.price] }
  end

  def register_pde
    @opportunity = Opportunity.find(skills_params[:id])
  end

  protected

  def skills_params
    params
      .merge(params.permit(opportunities: Opportunity.attribute_whitelist))
      .permit(
        :id,
        :organization_id,
        :competency_ids,
        :opportunity_category_id,
        :zipcode,
        :city,
        :facility_name_dropdown,
        :state,
        :internal_only,
        :miles,
        :public_ideas,
        :public_questions,
        :public_pacs,
        :current_opportunities,
        :current_recommendations,
        :form_of_learning_id,
        :popular,
        :newest,
        :trending
      )
  end
end
