package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Combinational_entryContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Combinational_entryContextExt extends AbstractBaseExt {

	public Combinational_entryContextExt(Combinational_entryContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Combinational_entryContext getContext() {
		return (Combinational_entryContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).combinational_entry());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Combinational_entryContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Combinational_entryContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}