package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Procedural_timing_control_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Procedural_timing_control_statementContextExt extends AbstractBaseExt {

	public Procedural_timing_control_statementContextExt(Procedural_timing_control_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Procedural_timing_control_statementContext getContext() {
		return (Procedural_timing_control_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).procedural_timing_control_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Procedural_timing_control_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Procedural_timing_control_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}