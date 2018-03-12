package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Tf_idContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Tf_idContextExt extends AbstractBaseExt {

	public Tf_idContextExt(Tf_idContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Tf_idContext getContext() {
		return (Tf_idContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).tf_id());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Tf_idContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Tf_idContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}