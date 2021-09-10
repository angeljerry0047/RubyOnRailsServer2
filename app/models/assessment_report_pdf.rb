require 'prawn'
require 'prawn/table'  # FIXME: (cmhobbs+tyreldension) move this require
class AssessmentReportPdf < Prawn::Document
  attr_reader :assessment_report, :document

  # Values used for the manual design:

  # This is the default value for the margin box
  #
  BOX_MARGIN   = 40

  # Additional indentation to keep the line measure with a reasonable size
  #
  INNER_MARGIN = 10

  ICON_WIDTH = 32

  # Vertical Rhythm settings
  #
  RHYTHM  = 10
  LEADING = 2

  # Colors
  RGB_TO_HEX = ->(arr) { arr.map { |n| n.to_s(16) }.join }

  BLACK       = '000000'.freeze
  LIGHT_GRAY  = RGB_TO_HEX.call([223, 223, 223])
  MEDIUM_GRAY = RGB_TO_HEX.call([128, 130, 133])
  DARK_GRAY   = RGB_TO_HEX.call([54, 54, 54])
  BLUE        = RGB_TO_HEX.call([59, 119, 181])
  ORANGE      = RGB_TO_HEX.call([217, 130, 62])
  GREEN       = RGB_TO_HEX.call([103, 192, 116])
  LIGHT_BLUE  = RGB_TO_HEX.call([74, 115, 214])
  CAPACITY_COLOR = '005AFF'.freeze

  def initialize(assessment_report)
    @assessment_report = assessment_report

    # Beware of the super vs super() ;)
    super()

    # font_families.update('Myriad' => {
    #                        bold: Rails.root.join('app/assets/fonts/myriad-pro/MyriadWebPro-Bold.ttf').to_s,
    #                        italic: Rails.root.join('app/assets/fonts/myriad-pro/MyriadWebPro-Italic.ttf').to_s,
    #                        normal: Rails.root.join('app/assets/fonts/myriad-pro/MyriadWebPro.ttf').to_s,
    #                        bold_italic: Rails.root.join('app/assets/fonts/myriad-pro/myriadprobolditalic.ttf').to_s
    #                      })

    # font 'Myriad', size: 10

    font_families.update('Roboto' => {
                           bold: Rails.root.join('app/assets/fonts/roboto/Roboto-Bold.ttf').to_s,
                           italic: Rails.root.join('app/assets/fonts/roboto/Roboto-Italic.ttf').to_s,
                           normal: Rails.root.join('app/assets/fonts/roboto/Roboto-Regular.ttf').to_s,
                           bold_italic: Rails.root.join('app/assets/fonts/roboto/Roboto-BoldItalic.ttf').to_s
                         })

    font 'Roboto', size: 10

    preamble!

    groups.each_with_index do |group_name, i|
      section(group_name, i != 0)
    end
  end

  #
  # renders the individual sections
  #
  def section(group, new_page)
    if new_page
      start_new_page
      header('')
      font('Roboto', style: :bold, size: 16) do
        text(
          "#{assessment_report.user.name.possessive} Performance<i><b>GPA</b></i>\u2122 Assessment Individual Report (cont.)", {
            inline_format: true, color: CAPACITY_COLOR
          }
        )
      end
    end

    stroke_color ORANGE
    fill_color 'FFFFFF'
    move_down RHYTHM * 2

    font 'Roboto', size: 13
    table(
      [
        [
          { image: icon_for(group), scale: 0.55 },
          "#{group.name.capitalize} Capacity - #{assessment_report.group_capacity(group)}",
          assessment_report.gross_score_for(group)
        ]
      ],
      width: bounds.right + INNER_MARGIN,
      row_colors: [color_for(group)], cell_style: { borders: [] }
    ) do
      column(0).style width: 35
      column(2).style align: :right
      column(2).style padding_right: 10
      column(2).style padding_top: 8
      column(1).style padding_top: 8
    end

    font 'Roboto', size: 10
    move_down RHYTHM * 2
    fill_color BLACK
    capacity = assessment_report.group_capacity(group)
    if capacity == 'Organizational Stakeholder'
      group_header_text = "#{assessment_report.user.name.possessive} scope of #{group.name} is an Organizational Stakeholder".upcase
    else
      group_header_text = "#{assessment_report.user.name.possessive} scope of #{group.name} is limited to their #{capacity} area/department".upcase
    end

    font('Roboto', style: :bold, size: 11) do
      text group_header_text
    end

    move_down RHYTHM * 1
    text assessment_report.blurb_about_group(group.name)
    move_down RHYTHM * 2

    font('Roboto', style: :bold, size: 12) do
      text 'competencies suggested'.upcase
    end

    move_down RHYTHM * 1

    font('Roboto', size: 10)
    assessment_report.competencies_needed_for(group).each do |comp|
      text comp.name
      text(comp.description.present? ? comp.description : '')
      text ' '
    end
  end

  def preamble!
    header("\nPerformance<i><b>GPA</b></i>\u2122 Overall Score: #{@assessment_report.gross_score}")
    top = cursor

    width = bounds.right / 2.0
    bounding_box([0, top], width: width, height: 180) do
      font('Roboto', size: 14) do
        text(
          "#{assessment_report.user.name.possessive} Performance<i><b>GPA</b></i>\u2122\nAssessment Individual Report", {
            inline_format: true, style: :bold, color: CAPACITY_COLOR
          }
        )
      end

      move_down RHYTHM * 2
      fill_color BLACK

      font('Roboto', size: 12) do
        text "Performance<i><b>GPA</b></i>\u2122 Overall Capacity: #{@assessment_report.overall_capacity}",
             { style: :bold, inline_format: true }
      end
      stroke_color 'FFFFFF'

      font('Roboto', size: 8)

      move_down 5

      table([['000 - 105 ', 'Positional', 'Driven to achieve individual success.'],
             ['106 - 267 ', 'Functional', 'Driven to achieve departmental success.'],
             ['268 - 300 ', 'Organizational Stakeholder',
              'Driven to achieve organizational success']], position: :left, cell_style: { padding_right: 1, borders: [] })

      stroke_color BLACK
    end

    bounding_box([width + 20, top], width: width, height: 200) do
      vertical_margins = 10
      increment = (bounds.right - bounds.left - ICON_WIDTH) / 6.0

      7.times do |i|
        stroke_color(i.even? ? MEDIUM_GRAY : DARK_GRAY)

        tt = (i * 50) / 3

        if tt % 50 == 0
          shift = tt == 0 ? 3 : 8
          draw_text tt.to_s, at: [(increment * i) + ICON_WIDTH - shift, 0]
        end
        dash(3)
        stroke_vertical_line(bounds.bottom + 8, bounds.top, at: (increment * i) + ICON_WIDTH)
      end
      # end

      groups.each_with_index do |group, i|
        render_bar_for_group(group, i)
      end
    end
  end

  def groups
    assessment_report.question_groups.sort { |a, b| a.name[2] <=> b.name[2] }
  end

  def color_for(group)
    # colors = {
    #   leadership: LIGHT_BLUE,
    #   influence: ORANGE,
    #   performance: GREEN
    # }

    colors = {
      leadership: CAPACITY_COLOR,
      influence: CAPACITY_COLOR,
      performance: CAPACITY_COLOR
    }

    colors.fetch(group.name.to_sym) { CAPACITY_COLOR }
  end

  def icon_for(group)
    icons = {
      leadership: 'app/assets/images/icon_leadership.png',
      influence: 'app/assets/images/icon_influence.png',
      performance: 'app/assets/images/icon_performance.png'
    }

    icons.fetch(group.name.to_sym) { 'app/assets/images/icon_leadership.png' }
  end

  #
  # render bar for graph for a given group
  #
  def render_bar_for_group(group, i)
    score = @assessment_report.gross_score_for(group) || 0
    rectangle_height = 30
    spacing = 30
    fill_color color_for(group)
    stroke_color color_for(group)

    multiple = ((bounds.right - ICON_WIDTH) / 100.0)

    move_down 15

    image graph_icon_for(group), width: 40, position: -15

    fill do
      rectangle [bounds.left + ICON_WIDTH, bounds.top - spacing + 8 - i * (rectangle_height + spacing)], score * multiple,
                rectangle_height
    end
  end

  def graph_icon_for(group)
    graph_icons = {
      leadership: 'app/assets/images/pdf/leadership-icon-regular.png',
      influence: 'app/assets/images/pdf/influence-icon-regular.png',
      performance: 'app/assets/images/pdf/performance-icon-regular.png'
    }

    graph_icons.fetch(group.name.to_sym) { 'app/assets/images/pdf/leadership-icon-regular.png' }
  end

  def header(str)
    header_box do
      image Rails
        .root
        .join('app/assets/images/s2mentor_top_banner_logo_blue_small.png').to_s,
            position: :left,
            vposition: 40,
            scale: 0.60

      # bounding_box([INNER_MARGIN])
      font('Roboto', size: 20, style: :bold) do
        fill_color BLUE

        bounding_box([0, cursor], width: bounds.right - BOX_MARGIN) do
          text(str, valign: 20, align: :right, inline_format: true, color: CAPACITY_COLOR)
        end
      end
    end
  end

  def header_box(&block)
    bounding_box([-bounds.absolute_left, cursor + BOX_MARGIN],
                 width: bounds.absolute_left + bounds.absolute_right,
                 height: BOX_MARGIN * 2 + RHYTHM * 1) do
                   fill_color LIGHT_GRAY
                   fill_rectangle([bounds.left, bounds.top],
                                  bounds.right,
                                  bounds.top - bounds.bottom)
                   fill_color BLACK

                   indent(BOX_MARGIN + INNER_MARGIN, &block)
                 end

    move_down(RHYTHM * 2)
  end
end
