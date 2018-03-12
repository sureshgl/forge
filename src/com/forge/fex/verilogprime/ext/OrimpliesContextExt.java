package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.OrimpliesContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class OrimpliesContextExt extends AbstractBaseExt {

	public OrimpliesContextExt(OrimpliesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public OrimpliesContext getContext() {
		return (OrimpliesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).orimplies());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof OrimpliesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + OrimpliesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}