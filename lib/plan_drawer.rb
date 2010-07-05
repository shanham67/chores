class PlanDrawer

  def self.draw_by_date( plans )
    pdf = PDF::Writer.new( :orientation => :landscape )
    pdf.start_columns(3)
    plans.each do |plan|
      pdf.text( "<b>" + plan.human_date + "</b>", :font_size => 12)
      plan.chore_lists.each do |cl|
         pdf.text( "<b>" + cl.worker.name + "</b>", :font_size => 12)
         cl.assignments.each do |a|
#            pdf.text( a.task.duration.to_s + " " + a.task.description , :left=> 5)
           pdf.text( a.task.description + " (" + a.task.duration.to_s + ")" , :font_size => 10, :left=> 5)
         end
      end
      pdf.start_new_page
    end
    pdf.render
  end

  def self.draw_by_worker( plans )
#    pdf = PDF::Writer.new( :orientation => :landscape )
    pdf = PDF::Writer.prepress( :orientation => :portrait, :top_margin => 10 )
    pdf.start_columns(3)

    Worker.all.each do |w|

      pdf.text( "<b>" + w.name + "</b>", :font_size => 9)
      plans.each do |plan|

        pdf.text( "<b>" + plan.human_date + "</b>", :font_size => 9)
        cl = plan.chore_lists.find_by_worker_id( w )
        unless cl.nil?
          cl.assignments.each do |a|
            pdf.text( a.task.description + " (" + a.task.duration.to_s + ")" , :font_size => 8, :left=> 5)
          end
        end
      end
      pdf.start_new_page
    end
    pdf.render
  end
end
