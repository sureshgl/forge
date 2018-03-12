package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Udp_input_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Udp_input_declarationContextExt extends AbstractBaseExt {

	public Udp_input_declarationContextExt(Udp_input_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Udp_input_declarationContext getContext() {
		return (Udp_input_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).udp_input_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Udp_input_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Udp_input_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}