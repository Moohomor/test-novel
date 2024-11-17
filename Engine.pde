class Engine {
  String text="";
  int pos=0;
  String mod="main";
  int els=-1,endif=-1;
  HashMap<String,String[]> mods=new HashMap<String,String[]>();
  Engine() {
    loadModules();
  }
  private void loadModules() {
    for (String name:new File(
      sketchPath("")).list()) {
      if (name.endsWith(".mod")) 
        mods.put(name.substring(0,name.length()-4),loadStrings(name));
    }
  }
  void step() {
    println("Step! Pos:",pos);
    if (pos>=mods.get(mod).length) {
      screen=new Menu();
      return;
    }
    for (;pos<mods.get(mod).length;pos++) {
      String line=mods.get(mod)[pos];
      String[] tokens = line.replace("\\n","\n").split(" ");
      String fn=tokens[0].trim();//.substring(1);
      println(mod,pos,"_"+fn+"_");
      if (line.equals("")||fn.contains("#"))
        continue;
      else if (fn.contains("-")) {
        pos++;
        break;
      } else if (fn.contains("tx")) {
        text=join(tokens," ").substring(3);
      } else if (fn.contains("append")) {
        text+=join(tokens," ").substring(7);
      } else if (fn.contains("bg")) {
        setbg(imdata.get(join(tokens,' ').substring(3)));
      } else if (tokens[1].contains("=")){
        vars.put(fn,tokens[2]);
        println(vars);
      } else if (fn.contains("if")) {
        for (int i=pos;i<mods.get(mod).length;i++) {
          String line1=mods.get(mod)[i];
          String[] tokens1 = line1.replace("\\n","\n").split(" ");
          String fn1=tokens1[0].trim();
          if (fn1.contains("else")) {
            els=i;
          } else if (fn.contains("endif")) {
            endif=i;
            break;
          }
        }
        if (!eval(preprocess(line.substring(3))).equals("1"))
          pos=els;
      } else if (fn.contains("else")) {
        pos=endif;
        break;
      }
    }
  }
  String eval(String expr) {
    String[] tokens = expr.replace("\\n","\n").split(" ");
    String fn=tokens[0].trim();
    if (fn.contains("choice")) {
      
    } else {
      if (tokens[1].contains("="))
        return tokens[0].trim().equals(tokens[2].trim())?"1":"0";
      else if (tokens[0].contains("numeric")) {
        float a=float(tokens[1]),
              b=float(tokens[3]);
        if (tokens[2].contains("<"))
          return a<b?"1":"0";
        else if (tokens[2].contains("<="))
          return a<=b?"1":"0";
        else if (tokens[2].contains(">"))
          return a>b?"1":"0";
        else if (tokens[2].contains(">="))
          return a>=b?"1":"0";
        else if (tokens[2].contains("="))
          return a==b?"1":"0";
        else throw new RuntimeException("Undefined `if` behaviour");
      }
    }
    return null;
  }
  String preprocess(String str) {
    int l=-1;
    ArrayList<String> r=new ArrayList<String>();
    for (int i=0;i<str.length();i++) {
      if (str.charAt(i)=='{') {
        l=i;
      } else if (str.charAt(i)=='}') {
        r.add(str.substring(l,i+1));
        l=-1;
      }
    }
    for (String i:r)
      str = str.replace(i,vars.get(i.substring(1,i.length()-1)));
    return str;
  }
}