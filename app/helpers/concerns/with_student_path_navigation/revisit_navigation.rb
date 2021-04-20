module WithStudentPathNavigation
  class RevisitNavigation < Navigation
    def right
      true
    end

    def icon
      'chevron-right'
    end

    def key
      :navigation_revisit
    end

    def clazz
      'btn btn-warning w-100'
    end

    def sibling_for(navigable)
      navigable.restart(current_user)
    end
  end
end
