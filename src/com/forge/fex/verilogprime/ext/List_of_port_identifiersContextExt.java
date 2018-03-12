package com.forge.fex.verilogprime.ext;

import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_port_identifiersContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_port_identifiers_part1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_port_identifiersContextExt extends AbstractBaseExt {

	public List_of_port_identifiersContextExt(List_of_port_identifiersContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_port_identifiersContext getContext() {
		return (List_of_port_identifiersContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_port_identifiers());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_port_identifiersContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_port_identifiersContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void getAlteredStringForWireDeclaration(String portName, Map<String, String> table, Params params) {
		List_of_port_identifiersContext ctx = getContext();
		List<List_of_port_identifiers_part1Context> list_of_port_identifiers_part1Contexts = ctx
				.list_of_port_identifiers_part1();
		Boolean found = false;
		for (List_of_port_identifiers_part1Context list_of_port_identifiers_part1Context : list_of_port_identifiers_part1Contexts) {
			if (list_of_port_identifiers_part1Context.port_identifier().extendedContext.getFormattedText()
					.equals(portName)) {
				list_of_port_identifiers_part1Context.extendedContext.getAlteredStringForWireDeclaration(portName,
						table, params);
				found = found || true;
			}
		}
		if (!found) {
			AbstractBaseExt.L.error("Couldnt find the port in the context");
		}
		params.setBeginingOfAlignemtText(parent.getRuleIndex() + 1);
	}
}