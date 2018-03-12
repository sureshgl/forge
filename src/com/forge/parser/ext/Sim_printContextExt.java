package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Sim_printContext;
import com.forge.runner.ForgeRunnerSession;

public class Sim_printContextExt extends AbstractBaseExt {

	public Sim_printContextExt(Sim_printContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sim_printContext getContext() {
		return (Sim_printContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sim_print());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sim_printContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Sim_printContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	public void getVerilogContextsFromForge(ForgeRunnerSession forgeRunnerSession, STGroupFile grp, ST module) {
		Sim_printContext ctx = getContext();
		ST Sim_print = grp.getInstanceOf("Sim_print");
		for (int i = 0; i < ctx.sim_print_properties().size(); i++) {
			if (ctx.sim_print_properties(i).logger() != null) {
				String log_level = ctx.sim_print_properties(i).logger().extendedContext.getFormattedText();
				Sim_print.add("log_level", log_level);
			}
			if (ctx.sim_print_properties(i).trigger_identifier() != null) {
				String trigger_name = ctx.sim_print_properties(i).trigger_identifier().simple_identifier().extendedContext.getFormattedText();
				Sim_print.add("trigger_name", trigger_name);
			}
			String sim_printname = ctx.sim_print_identifier().simple_identifier().extendedContext.getFormattedText();
			Sim_print.add("sim_printname", sim_printname);
			writeFile(forgeRunnerSession, Sim_print, "simprint_" + sim_printname, ".v");
		}
	}
}
