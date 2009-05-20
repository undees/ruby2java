class Class
  def annotation(name, anno_hash = {})
    name = name.to_s
    annotations[name] ||= {}
    anno_hash.each do |k,v|
      annotations[name][k] = v
    end
  end

  def annotations
    @annotations ||= {}
  end

  def static_annotation(name, anno_hash = {})
    name = name.to_s
    annotations[name] ||= {}
    anno_hash.each do |k,v|
      static_annotations[name][k] = v
    end
  end

  def static_annotations
    @static_annotations ||= {}
  end
end

